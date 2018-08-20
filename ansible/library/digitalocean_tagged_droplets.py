#!/usr/bin/env python

import argparse
import ast
import os
import re
import requests
import sys
from time import time

try:
    import ConfigParser
except ImportError:
    import configparser as ConfigParser

from ansible.module_utils.basic import *
from ansible.module_utils.urls import *

DOCUMENTATION = '''
---
module: digitalocean_tag_facts
short_description: Get IP addresses of all droplets matching tag.
description:
  - Get IP addresses of all droplets matching tag.
version_added: '1.0'
author: "Mark Mims (@m_3)"
options:
  - tag:
      description: "tag to match"
'''

EXAMPLES = '''
# Gather tag IP addresses
- name: get my tag IPs
  digitalocean_tag_facts:
    tag: "dev"
'''

RETURN = '''
---
tag_ip_addrs:
  description: IPs of tagged droplets
  returned: success
  type: string
  sample: ["1.2.3.4", ... ]
'''

try:
    import json
except ImportError:
    import simplejson as json


class DoManager:
    def __init__(self, api_token):
        self.api_token = api_token
        self.api_endpoint = 'https://api.digitalocean.com/v2'
        self.headers = {'Authorization': 'Bearer {0}'.format(self.api_token),
                        'Content-type': 'application/json'}
        self.timeout = 60

    def _url_builder(self, path):
        if path[0] == '/':
            path = path[1:]
        return '%s/%s' % (self.api_endpoint, path)

    def send(self, url, method='GET', data=None):
        url = self._url_builder(url)
        data = json.dumps(data)
        try:
            if method == 'GET':
                resp_data = {}
                incomplete = True
                while incomplete:
                    resp = requests.get(url, data=data, headers=self.headers, timeout=self.timeout)
                    json_resp = resp.json()

                    for key, value in json_resp.items():
                        if isinstance(value, list) and key in resp_data:
                            resp_data[key] += value
                        else:
                            resp_data[key] = value

                    try:
                        url = json_resp['links']['pages']['next']
                    except KeyError:
                        incomplete = False

        except ValueError as e:
            sys.exit("Unable to parse result from %s: %s" % (url, e))
        return resp_data

    def all_active_droplets(self):
        resp = self.send('droplets/')
        return resp['droplets']

    def all_regions(self):
        resp = self.send('regions/')
        return resp['regions']

    def all_images(self, filter_name='global'):
        params = {'filter': filter_name}
        resp = self.send('images/', data=params)
        return resp['images']

    def sizes(self):
        resp = self.send('sizes/')
        return resp['sizes']

    def all_ssh_keys(self):
        resp = self.send('account/keys')
        return resp['ssh_keys']

    def all_domains(self):
        resp = self.send('domains/')
        return resp['domains']

    def show_droplet(self, droplet_id):
        resp = self.send('droplets/%s' % droplet_id)
        return resp['droplet']

    def all_tags(self):
        resp = self.send('tags/')
        return resp['tags']


class DigitalOceanInventory(object):

    ###########################################################################
    # Main execution path
    ###########################################################################

    def get_inventory(self):
        """Main execution path """

        # DigitalOceanInventory data
        self.data = {}  # All DigitalOcean data
        self.inventory = {}  # Ansible Inventory

        # Define defaults
        self.use_private_network = False
        self.group_variables = {}

        # Read settings, environment variables, and CLI arguments
        self.read_settings()
        self.read_environment()
        self.read_cli_args()

        # Verify credentials were set
        if not hasattr(self, 'api_token'):
            msg = 'Could not find values for DigitalOcean api_token. They must be specified via either ini file, ' \
                  'command line argument (--api-token), or environment variables (DO_API_TOKEN)\n'
            sys.stderr.write(msg)
            sys.exit(-1)

        # env command, show DigitalOcean credentials
        if self.args.env:
            print("DO_API_TOKEN=%s" % self.api_token)
            sys.exit(0)


        self.manager = DoManager(self.api_token)

        # Pick the json_data to print based on the CLI command
        if self.args.droplets:
            self.load_from_digital_ocean('droplets')
            json_data = {'droplets': self.data['droplets']}
        elif self.args.regions:
            self.load_from_digital_ocean('regions')
            json_data = {'regions': self.data['regions']}
        elif self.args.images:
            self.load_from_digital_ocean('images')
            json_data = {'images': self.data['images']}
        elif self.args.sizes:
            self.load_from_digital_ocean('sizes')
            json_data = {'sizes': self.data['sizes']}
        elif self.args.ssh_keys:
            self.load_from_digital_ocean('ssh_keys')
            json_data = {'ssh_keys': self.data['ssh_keys']}
        elif self.args.domains:
            self.load_from_digital_ocean('domains')
            json_data = {'domains': self.data['domains']}
        elif self.args.tags:
            self.load_from_digital_ocean('tags')
            json_data = {'tags': self.data['tags']}
        elif self.args.all:
            self.load_from_digital_ocean()
            json_data = self.data
        elif self.args.host:
            json_data = self.load_droplet_variables_for_host()
        else:    # '--list' this is last to make it default
            self.load_from_digital_ocean('droplets')
            self.build_inventory()
            json_data = self.inventory

        # if self.args.pretty:
            # print(json.dumps(json_data, indent=2))
        # else:
            # print(json.dumps(json_data))
        return json_data

    ###########################################################################
    # Script configuration
    ###########################################################################

    def read_settings(self):
        """ Reads the settings from the digital_ocean.ini file """
        config = ConfigParser.SafeConfigParser()
        config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'digital_ocean.ini')
        config.read(config_path)

        # Credentials
        if config.has_option('digital_ocean', 'api_token'):
            self.api_token = config.get('digital_ocean', 'api_token')

        # Private IP Address
        if config.has_option('digital_ocean', 'use_private_network'):
            self.use_private_network = config.getboolean('digital_ocean', 'use_private_network')

        # Group variables
        if config.has_option('digital_ocean', 'group_variables'):
            self.group_variables = ast.literal_eval(config.get('digital_ocean', 'group_variables'))

    def read_environment(self):
        """ Reads the settings from environment variables """
        # Setup credentials
        if os.getenv("DO_API_TOKEN"):
            self.api_token = os.getenv("DO_API_TOKEN")
        if os.getenv("DO_API_KEY"):
            self.api_token = os.getenv("DO_API_KEY")

    def read_cli_args(self):
        """ Command line argument processing """
        parser = argparse.ArgumentParser(description='Produce an Ansible Inventory file based on DigitalOcean credentials')

        parser.add_argument('--list', action='store_true', help='List all active Droplets as Ansible inventory (default: True)')
        parser.add_argument('--host', action='store', help='Get all Ansible inventory variables about a specific Droplet')

        parser.add_argument('--all', action='store_true', help='List all DigitalOcean information as JSON')
        parser.add_argument('--droplets', '-d', action='store_true', help='List Droplets as JSON')
        parser.add_argument('--regions', action='store_true', help='List Regions as JSON')
        parser.add_argument('--images', action='store_true', help='List Images as JSON')
        parser.add_argument('--sizes', action='store_true', help='List Sizes as JSON')
        parser.add_argument('--ssh-keys', action='store_true', help='List SSH keys as JSON')
        parser.add_argument('--domains', action='store_true', help='List Domains as JSON')
        parser.add_argument('--tags', action='store_true', help='List Tags as JSON')

        parser.add_argument('--pretty', '-p', action='store_true', help='Pretty-print results')

        parser.add_argument('--env', '-e', action='store_true', help='Display DO_API_TOKEN')
        parser.add_argument('--api-token', '-a', action='store', help='DigitalOcean API Token')

        self.args = parser.parse_args()

        if self.args.api_token:
            self.api_token = self.args.api_token

        # Make --list default if none of the other commands are specified
        if (not self.args.droplets and not self.args.regions and
                not self.args.images and not self.args.sizes and
                not self.args.ssh_keys and not self.args.domains and
                not self.args.tags and
                not self.args.all and not self.args.host):
            self.args.list = True

    ###########################################################################
    # Data Management
    ###########################################################################

    def load_from_digital_ocean(self, resource=None):
        """Get JSON from DigitalOcean API """
        # We always get fresh droplets

        if resource == 'droplets' or resource is None:
            self.data['droplets'] = self.manager.all_active_droplets()
        if resource == 'regions' or resource is None:
            self.data['regions'] = self.manager.all_regions()
        if resource == 'images' or resource is None:
            self.data['images'] = self.manager.all_images()
        if resource == 'sizes' or resource is None:
            self.data['sizes'] = self.manager.sizes()
        if resource == 'ssh_keys' or resource is None:
            self.data['ssh_keys'] = self.manager.all_ssh_keys()
        if resource == 'domains' or resource is None:
            self.data['domains'] = self.manager.all_domains()
        if resource == 'tags' or resource is None:
            self.data['tags'] = self.manager.all_tags()

    def add_inventory_group(self, key):
        """ Method to create group dict """
        host_dict = {'hosts': [], 'vars': {}}
        self.inventory[key] = host_dict
        return

    def add_host(self, group, host):
        """ Helper method to reduce host duplication """
        if group not in self.inventory:
            self.add_inventory_group(group)

        if host not in self.inventory[group]['hosts']:
            self.inventory[group]['hosts'].append(host)
        return

    def build_inventory(self):
        """ Build Ansible inventory of droplets """
        self.inventory = {
            'all': {
                'hosts': [],
                'vars': self.group_variables
            },
            '_meta': {'hostvars': {}}
        }

        # add all droplets by id and name
        for droplet in self.data['droplets']:
            for net in droplet['networks']['v4']:
                if net['type'] == 'private':
                    dest = net['ip_address']
                else:
                    continue

            self.inventory['all']['hosts'].append(dest)

            self.add_host(droplet['id'], dest)

            self.add_host(droplet['name'], dest)

            # groups that are always present
            for group in ('digital_ocean',
                          'region_' + droplet['region']['slug'],
                          'image_' + str(droplet['image']['id']),
                          'size_' + droplet['size']['slug'],
                          'distro_' + DigitalOceanInventory.to_safe(droplet['image']['distribution']),
                          'status_' + droplet['status']):
                self.add_host(group, dest)

            # groups that are not always present
            for group in (droplet['image']['slug'],
                          droplet['image']['name']):
                if group:
                    image = 'image_' + DigitalOceanInventory.to_safe(group)
                    self.add_host(image, dest)

            if droplet['tags']:
                for tag in droplet['tags']:
                    self.add_host(tag, dest)

            # hostvars
            info = self.do_namespace(droplet)
            self.inventory['_meta']['hostvars'][dest] = info

    def load_droplet_variables_for_host(self):
        """ Generate a JSON response to a --host call """
        host = int(self.args.host)
        droplet = self.manager.show_droplet(host)
        info = self.do_namespace(droplet)
        return {'droplet': info}

    ###########################################################################
    # Utilities
    ###########################################################################
    @staticmethod
    def to_safe(word):
        """ Converts 'bad' characters in a string to underscores so they can be used as Ansible groups """
        return re.sub(r"[^A-Za-z0-9\-.]", "_", word)

    @staticmethod
    def do_namespace(data):
        """ Returns a copy of the dictionary with all the keys put in a 'do_' namespace """
        info = {}
        for k, v in data.items():
            info['do_' + k] = v
        return info


class IpifyFacts(object):

    def __init__(self):
        self.api_url = module.params.get('api_url')

    def run(self):
        result = {
            'ipify_public_ip': None
        }
        (response, info) = fetch_url(
            module,
            self.api_url + "?format=json",
            force=True)
        if response:
            data = json.loads(response.read())
            result['ipify_public_ip'] = data.get('ip')
        return result


def main():
    global module
    module = AnsibleModule(
        argument_spec=dict(
            tag=dict(type='str', required=True),
        ),
        supports_check_mode=True,
    )
    inventory = DigitalOceanInventory()
    droplet_facts = inventory.get_inventory()
    digitalocean_facts_result = dict(
        changed=False,
        ansible_facts=droplet_facts[module.params.get('tag')])
    module.exit_json(**digitalocean_facts_result)


if __name__ == '__main__':
    main()

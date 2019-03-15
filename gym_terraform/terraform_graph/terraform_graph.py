""" Terraform praph
"""
import logging
import subprocess


class TerraformGraph():
    """ Terraform graph
    """

    def __init__(self, project, environment, project_dir, dry_run=False):
        """ init
        """
        self.log = logging.getLogger(type(self).__name__)
        self.log.debug("init")
        self.project = project
        self.environment = environment
        self.project_dir = project_dir
        self.dry_run = dry_run
        return

    def __del__(self):
        """ del
        """
        self.log.debug("del")
        return

    def add_layer(self, layer):
        """ adds layer
            args: layer name
            returns: None
        """
        self.log.debug("add_layer: %s" % layer)
        self._terraform_layer_action(layer, 'apply')
        return

    def remove_layer(self, layer):
        """ removes layer
            args: layer name
            returns: None
        """
        self.log.debug("remove_layer: %s" % layer)
        self._terraform_layer_action(layer, 'destroy')
        return

    def update_layer(self, layer, args=""):
        """ updates layer
            args: layer name
            returns: None
        """
        self.log.debug("update_layer: %s %s" % (layer, args))
        self._terraform_layer_action(layer, 'apply', args)
        return

    def get_layer_nodes(self, layer):
        """ get nodes for layer
            args: layer name
            returns: nodemap of some sort
        """
        self.log.debug("get_layer_nodes: %s" % layer)
        self._terraform_layer_action(layer, 'graph')
        return

    def reset_layer_storage(self, layer):
        """ reset storage for layer
            args: layer name
            returns: None
        """
        self.log.debug("reset_layer_storage: %s" % layer)
        self._terraform_layer_action(layer, '???')
        return

    def _terraform_layer_action(self, layer, action, args=""):
        """ perform terraform action for layer
            args:
                - layer name
                - action
            returns: None

            need to basically reproduce the terraform-layer subcommand here
            that's `tf -p <project> -e <environment> <layer> <action>
        """
        self.log.debug("performing terraform %s for layer %s"
                       % (action, layer))
        if args != "":
            self.log.debug("passing terraform args: %s" % args)

        cmd = "echo " if self.dry_run else ""
        cmd += "bin/tf -p %s -e %s %s %s %s" % (self.project,
                                                self.environment,
                                                layer,
                                                action,
                                                args)
        self.log.debug("running: %s" % cmd)
        result = subprocess.run(cmd.split(' '),
                                shell=False,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT,
                                cwd=self.project_dir)
        self.log.debug(result.stdout)

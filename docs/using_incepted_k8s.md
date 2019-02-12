# Using Incepted k8s

## Config

The installation for incepted k8s copies over config

    cp /etc/kubernetes/admin.conf /root/.kube/config

so that kubectl works fine from any of the k8s master nodes.

However, to get to this from outside, you've got to:

    rsync -azvP -e 'ssh -F ~/.ssh/<project>-<env>-ssh.cfg' <ip-of-k8s-master>:/etc/kubernete/admin.conf $HOME/.kube/<project>-<env>-k8s.yml


## Running `kubectl`

There are a couple of different options:

### Proxy

On a k8s master, run the proxy server

    kubectl proxy --port 8080

Forward `8080`
 
    ssh -F ~/.ssh/mmm-dev-ssh.cfg 10.133.5.188 -L8080:localhost:8080

and edit `~/.kube/<project>-<env>-k8s.yml` to point to `http://localhost:8080`
(no tls).

### Manual Flags

Forward `6443`

    ssh -F ~/.ssh/mmm-dev-ssh.cfg 10.133.5.188 -L6443:10.133.5.188:6443

Then run `kubectl` with an extra flag `--insecure-skip-tls-verify`

    kubectl --kubeconfig ~/.kube/<project>-<env>-k8s.yml --insecure-skip-tls-verify get pods --all-namespaces

We'd have to add this to the helm and the k8s terraform providers.

### Config Changes

Forward `6443`

    ssh -F ~/.ssh/mmm-dev-ssh.cfg 10.133.5.188 -L6443:10.133.5.188:6443

Edit `~/.kube/<project>-<env>-k8s.yml`, and

1. comment out the `certificate-authority-data`
2. add `insecure-skip-tls-verify: true`

then `kubectl` works fine without any special flags.

This allows the helm and k8s terraform providers to work without modifications.

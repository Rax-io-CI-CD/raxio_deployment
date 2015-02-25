## RaxIO deployment scripts

### New Environment

#### INITIAL

- spin up GREEN load balancer
- spin up BLUE load balancer
- spin up X GREEN servers
- spin up X BLUE servers (total count X+X)
- add BLUE servers to host group BLUE
- add BLUE servers to BLUE load balancer
- deploy application on BLUE servers
- test against BLUE load balancer

````
ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS=&apos;-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o ControlPersist=60s -o PubkeyAuthentication=yes&apos; ansible-playbook deploy.yml -i inventory/production/ --tags "green-lb,blue-lb,green-nodes,blue-nodes,deploy,test-blue" -vvvv --private-key /var/lib/jenkins/.ssh/id_rsa --extra-vars "group_environ=production"
````

#### INITIAL-RESCUE

- remove BLUE servers (exact_count: true, count: X, remove_youngest: true)
- remove BLUE load balancer

````
ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS=&apos;-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o ControlPersist=60s -o PubkeyAuthentication=yes&apos; ansible-playbook deploy.yml -i inventory/production/ --tags "clean-up-blue" -vvvv --private-key /var/lib/jenkins/.ssh/id_rsa --extra-vars "group_environ=production"
````

#### DEPLOY-LIVE

- spin up GREEN load balancer (existing)
- spin up BLUE load balancer (existing)
- add BLUE group to GREEN load balancer
- drain, disable, remove GREEN servers from GREEN load balancer
- add GREEN group to BLUE load balancer
- test against GREEN load balancer

````
ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS=&apos;-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o ControlPersist=60s -o PubkeyAuthentication=yes&apos; ansible-playbook deploy.yml -i inventory/production/ --tags "green-lb,blue-lb,blue-to-green,test-green" -vvvv --private-key /var/lib/jenkins/.ssh/id_rsa --extra-vars "group_environ=production"
````

DEPLOY-LIVE RESCUE
- spin up GREEN load balancer (existing)
- spin up BLUE load balancer (existing)
- get all nodes in GREEN load balancer and add to GREEN group
- get all nodes in BLUE load balancer and add to BLUE group
- add BLUE group to GREEN load balancer
- drain, disable, remove GREEN servers from GREEN load balancer
- add GREEN servers to BLUE load balancer

````
ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS=&apos;-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o ControlPersist=60s -o PubkeyAuthentication=yes&apos; ansible-playbook deploy.yml -i inventory/production/ --tags "green-lb,blue-lb,blue-to-green" -vvvv --private-key /var/lib/jenkins/.ssh/id_rsa --extra-vars "group_environ=production"
````

CLEAN-UP
- remove BLUE load balancer
- remove GREEN servers (exact_count: true, count: X)

````
ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS=&apos;-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o ControlPersist=60s -o PubkeyAuthentication=yes&apos; ansible-playbook deploy.yml -i inventory/production/ --tags "clean-up-green" -vvvv --private-key /var/lib/jenkins/.ssh/id_rsa --extra-vars "group_environ=production"
````
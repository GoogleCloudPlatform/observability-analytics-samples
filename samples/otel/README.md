Building a simple LAMP stack and deploying Application using Ansible Playbooks.
-------------------------------------------

These playbooks require Ansible 1.2.

These playbooks are meant to be a reference and starter's guide to building
Ansible Playbooks. These playbooks were tested on Debian 12.x.

This LAMP stack can be on a single node or multiple nodes. The inventory file
'hosts' defines the nodes in which the stacks should be configured.

        [backend_collectors]
        34.68.224.251
        34.16.61.198

        [nginx]
        34.28.88.229

        [app_servers]
        34.170.126.62
        35.192.123.89


The stack can be deployed using the following
command:

        ansible-playbook -i hosts site.yml

Once done, you can check the results in the Cloud Monitoring Console.
You should see a simple test page and a list of databases retrieved from the
database server.

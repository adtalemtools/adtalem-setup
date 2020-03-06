#!/bin/bash
source ~/adtalem-setup/.setup_vars

# Reprovision the VM.
cd ~/vms/$MYSTACK
vagrant reload --provision
vagrant up
vagrant ssh

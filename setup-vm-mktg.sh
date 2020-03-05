#!/bin/bash

# Set the VM name.
VM_NAME=adtalem.local

# Remove existing VM files.
vboxmanage list runningvms | gsed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate 2> /dev/null
vboxmanage controlvm "$VM_NAME" poweroff 2> /dev/null
vboxmanage unregistervm "$VM_NAME" --delete 2> /dev/null 
vagrant destroy -f 2> /dev/null 
cd ~/VirtualBox\ VMs
rm -rf "$VM_NAME" 2> /dev/null 

# Build the VM.
cd ~/vms/CMS-Drupal-MKTG
vagrant up
vagrant ssh


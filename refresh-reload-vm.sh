#!/bin/bash
source ~/CMS-Drupal-Setup-Scripts/.setup_vars

# Reprovision the VM.
cd ~/vms/$MYSTACK
vagrant reload --provision
vagrant up
vagrant ssh

![Image description](adtalem-mt-logo.png)

Adtalem Drupal Setup Scripts
====

Scripts that setup a local development environment on Mac OSX for of Adtalem Global Education's Drupal CMS projects.

## Requirements

This package includes a software check and install script for the following:

- Homebrew
- Virtualbox
- Vagrant
- Pip
- Ansible
- Ruby
- Composer
- XCode Tools

## Pre-requisites

1. You must generate an SSH key pair that will be used for these projects only. (RSA, 4096)
```js
ssh-keygen -f ~/.ssh/adtalem_rsa -t rsa -b 4096 -C "your.email@adtalem.com" -N ""
```

2. Copy the public key to your clipboard so it can be added to your cloud accounts.

```js
pbcopy < ~/.ssh/adtalem_rsa.pub
```
   
3. Add it to both your ATGE Acquia Cloud account and your ATGE Github account.

     ###### **ADD AN ACQUIA CLOUD KEY**
   <a href="https://cloud.acquia.com/a/profile/ssh-keys">https://cloud.acquia.com/a/profile/ssh-keys</a>
     ###### **ADD A GITHUB KEY** 
   <a href="https://github.com/settings/keys">https://github.com/settings/keys</a>
   
   
4. You must create a repository fork for each stack in your ATGE Github account.

     ###### **THE CMS-Drupal-MKTG STACK REPO**
   <a href="https://github.com/DeVryEducationGroup/CMS-Drupal-MKTG">https://github.com/DeVryEducationGroup/CMS-Drupal-MKTG</a>
     ###### **THE CMS-Drupal-ECOM STACK REPO**  
   <a href="https://github.com/DeVryEducationGroup/CMS-Drupal-ECOM">https://github.com/DeVryEducationGroup/CMS-Drupal-ECOM</a>

5. Verify that the following applications are installed on your Mac:

    ###### **Homebrew**
    ###### **Virtualbox**
    ###### **Vagrant**
    ###### **Pip**
    ###### **Ansible**
    ###### **Ruby**
    ###### **Composer**
    ###### **XCode Tools**
   
   You can verify and install these all at once after installation (see below).
   
   
## Installation

Install from your home directory in the OSX terminal.

You will need the following info:

1. The name of your SSH key pair as created above.
2. Your Adtalem Github username (ex. D********). 
3. Your Github Developer Access Token (from <a href="https://github.com/settings/tokens">https://github.com/settings/tokens</a>).
4. Your Acquia API Token and Secret (from <a href="https://cloud.acquia.com/a/profile/tokens">https://cloud.acquia.com/a/profile/tokens</a>).

Enter the commands below to install.

```js
cd ~/
git clone git@github.com:CMS-Drupal-Setup-Scripts/setup-scripts.git

## Check Installed Software (Optional)
bash setup-scripts/setup_apps.sh

## Installation
bash setup-scripts/setup.sh
```

## Refreshing and Syncing

Refresh and sync from your home directory in the OSX terminal. Enter the commands below.

## Refresh Sites by Stack

```js
bash setup-scripts/refresh-sites-mktg.sh
bash setup-scripts/refresh-sites-ecom.sh
```
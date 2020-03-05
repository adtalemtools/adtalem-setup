#!/bin/bash

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[1;96m'
LIGHTBLUE='\033[1;27m'
LIGHTERBLUE='\033[1;33m'
GRAY='\033[1;231m'
BOLD='\033[1;0m'
NC='\033[0m'

echo -e "\n"
echo -e "${BLUE}Installing CMS-Drupal-ECOM local environment: ${NC}"
echo -e "${LIGHTBLUE}Started: "`date`"${NC}\n"
sleep 3

mkdir ~/vms 2> /dev/null
cd ~/vms/
read -p "$(echo -e $LIGHTERBLUE"Enter the name of your Acquia/Github private key "$NC"(ex. adtalem_rsa): ")" MYPRIVATEKEY
read -p "$(echo -e $LIGHTERBLUE"Enter your ATGE Github username "$NC"(ex. D********): ")"  MYDNUMBER
read -p "$(echo -e $LIGHTERBLUE"Enter your ATGE Github access token "$NC"(from https://github.com/settings/tokens): ")" MYGITTOKEN
read -p "$(echo -e $LIGHTERBLUE"Enter your Acquia Cloud API Token "$NC"(from https://cloud.acquia.com/a/profile/tokens): ")" MYACQUIATOKEN
read -p "$(echo -e $LIGHTERBLUE"Enter your Acquia Cloud API Secret "$NC"(from https://cloud.acquia.com/a/profile/tokens): ")" MYACQUIASECRET

echo -e "\n"

SAVEDGITTOKEN='MYGITTOKEN="'$MYGITTOKEN'"'
echo $SAVEDGITTOKEN >> ~/CMS-Drupal-Setup-Scripts/.setup_vars
SAVEDACQUIATOKEN='MYACQUIATOKEN="'$MYACQUIATOKEN'"'
echo $SAVEDACQUIATOKEN >> ~/CMS-Drupal-Setup-Scripts/.setup_vars
SAVEDACQUIASECRET='MYACQUIASECRET="'$MYACQUIASECRET'"'
echo $SAVEDACQUIASECRET >> ~/CMS-Drupal-Setup-Scripts/.setup_vars

rm -rf CMS-Drupal-ECOM

set -e

ssh-add ~/.ssh/"$MYPRIVATEKEY" 2> /dev/null

echo -e "${BLUE}CLONING THE $MYDNUMBER/CMS-Drupal-ECOM REPOSITORY${NC}"
git clone git@github.com:"$MYDNUMBER"/CMS-Drupal-ECOM.git
cp ~/CMS-Drupal-Setup-Scripts/setup-sync-ecom.sh ~/vms/CMS-Drupal-ECOM/scripts/setup-sync.sh
cp ~/CMS-Drupal-Setup-Scripts/bash_profile ~/vms/CMS-Drupal-ECOM/scripts/bash_profile
cp ~/CMS-Drupal-Setup-Scripts/local.config-ecom.yml ~/vms/CMS-Drupal-ECOM/box/local.config.yml 

echo -e "${GREEN}$MYDNUMBER/CMS-Drupal-ECOM repository fork has been cloned.${NC}\n"
sleep 3

echo -e "${BLUE}ADDING UPSTREAM REPOSITORY${NC}"
cd ~/vms/CMS-Drupal-ECOM/
git remote add upstream git@github.com:DeVryEducationGroup/CMS-Drupal-ECOM.git
git fetch upstream 2> /dev/null
echo -e "${GREEN}DeVryEducationGroup/CMS-Drupal-ECOM has been added as an upstream repository.${NC}\n"
sleep 3

echo -e "${BLUE}UPDATING ORIGIN DEVELOP BRANCH${NC}"
cd ~/vms/CMS-Drupal-ECOM/
git merge upstream/develop
git rebase origin/develop
echo -e "${GREEN}$MYDNUMBER/CMS-Drupal-ECOM branch has been updated.${NC}\n"
sleep 3

echo -e "${BLUE}CREATING NEW LOCAL BRANCH${NC}"
read -p "$(echo -e $LIGHTERBLUE"Enter the name of your new local branch "$NC"(BECK-****, feature/new-feature): ")" MYLOCBRANCH
git fetch
git checkout -b $MYLOCBRANCH develop
echo -e "${GREEN}Your new branch $MYLOCBRANCH has been created and checked out.${NC}\n"
sleep 3

echo -e "${BLUE}INSTALLING VAGRANT PLUGINS${NC}"
ulimit -n 10000 2> /dev/null
vagrant plugin install vagrant-vbguest 2> /dev/null
vagrant plugin install vagrant-hostsupdater 2> /dev/null
vagrant plugin install vagrant-auto_network 2> /dev/null

if ! composer_loc="$(type -p "composer")" || [[ -z $composer_loc ]]; then
echo -e "${BLUE}\nINSTALLING COMPOSER${NC}"
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
exit $RESULT
mkdir ~/vms/CMS-Drupal-ECOM/vendor
mkdir ~/vms/CMS-Drupal-ECOM/vendor/bin
mv composer ~/vms/CMS-Drupal-ECOM/vendor/bin/
cd /usr/local/bin
rm -rf composer
ln -s ~/vms/CMS-Drupal-ECOM/vendor/bin/composer composer
fi

echo -e "${BLUE}\nADDING GITHUB ACCESS TOKEN${NC}"
composer config -g github-oauth.github.com "$MYGITTOKEN"
echo -e "${GREEN}Your Github access token has been added to the codebase.${NC}\n"
sleep 3

cd ~/vms/CMS-Drupal-ECOM/
composer clearcache 2> /dev/null

echo -e "${BLUE}LOCAL ECOM CODEBASE INSTALL${NC}"
read -e -p "Would you like to install your local codebase? (y/N)" choice1
[[ "$choice1" == [Yy]* ]] && composer install --prefer-dist || exit 0
cp ~/CMS-Drupal-Setup-Scripts/.setup_vars ~/vms/CMS-Drupal-ECOM/vendor/acquia/blt/scripts/blt/setup_vars
cp ~/CMS-Drupal-Setup-Scripts/bash_profile_ecom ~/vms/CMS-Drupal-ECOM/vendor/acquia/blt/scripts/blt/bash_profile
cp ~/CMS-Drupal-Setup-Scripts/post-provision-ecom.php ~/vms/CMS-Drupal-ECOM/vendor/acquia/blt/scripts/drupal-vm/post-provision.php

echo -e "${GREEN}Local codebase has been installed.${NC}"
sleep 3

echo -e "${BLUE}LOCAL ENVIRONMENT VM INSTALL${NC}"
read -e -p "Would you like to install your VM? (y/N)" choice2
[[ "$choice2" == [Yy]* ]] && bash ~/CMS-Drupal-Setup-Scripts/setup-vm-ecom.sh || exit 0
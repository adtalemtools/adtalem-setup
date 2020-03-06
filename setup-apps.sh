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
echo -e "${BLUE}Checking for Homebrew, Virtualbox, Vagrant, Pip, Ansible, Ruby, Composer, and XCode Tools installations. ${NC}"

# Install Xcode Command Line Tools
if ! xcode_loc="$(type -p xcode-select -p)" || [[ -z $xcode_loc ]]; then
    NOXCODE='NOXCODE="Xcode"'
    echo $NOXCODE >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Xcode Command Line Tools are not installed. ${NC}"
    NOXCODE=""
fi

# Install Ruby
if ! ruby_loc="$(type -p "brew")" || [[ -z $ruby_loc ]]; then
    NORUBY='NORUBY="Ruby"'
    echo $NORUBY >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Ruby is not installed. ${NC}"
    NORUBY=""
fi

# Install Homebrew
if ! brew_loc="$(type -p "brew")" || [[ -z $brew_loc ]]; then
    NOHOMEBREW='NOHOMEBREW="Homebrew"'
    echo $NOHOMEBREW >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Homebrew is not installed. ${NC}"
    NOHOMEBREW=""
fi

# Install Virtualbox >=5.1.14
if ! vb_loc="$(type -p "VBoxmanage")" || [[ -z $vb_loc ]]; then
    NOVBOX='NOVBOX="Virtualbox"'
    echo $NOVBOX >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Virtualbox is not installed. ${NC}"
    NOVBOX=""
fi

# Install Vagrant >=1.8.6
if ! vagrant_loc="$(type -p "vagrant")" || [[ -z $vagrant_loc ]]; then
    NOVAGRANT='NOVAGRANT="Vagrant"'
    echo $NOVAGRANT >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Vagrant is not installed. ${NC}"
    NOVAGRANT=""
fi

# Install pip
if ! pip_loc="$(type -p "pip")" || [[ -z $pip_loc ]]; then
    NOPIP='NOPIP="pip"'
    echo $NOPIP >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}pip is not installed. ${NC}"
    NOPIP=""
fi

# Install Ansible
if ! ansible_loc="$(type -p "ansible")" || [[ -z $ansible_loc ]]; then
    NOANSIBLE='NOANSIBLE="Ansible"'
    echo $NOANSIBLE >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Ansible is not installed. ${NC}"
    NOANSIBLE=""
fi

# Install Composer
if ! composer_loc="$(type -p "composer")" || [[ -z $composer_loc ]]; then
    NOCOMPOSER='NOCOMPOSER="Composer"'
    echo $NOCOMPOSER >> ~/adtalem-setup/.app_vars
    echo -e "${YELLOW}Composer is not installed. ${NC}"
    NOCOMPOSER=""
fi

if [ ! -f ~/adtalem-setup/.app_vars ]; then
echo -e "${LIGHTBLUE}No applications need to be installed. ${NC}"
   bash ~/adtalem-setup/setup-stack.sh
fi

source ~/adtalem-setup/.app_vars

echo -e "\n"
echo -e "Would you like to install these required applications?"
echo -e "\n"
read -p "$NORUBY $NOXCODE $NOHOMEBREW $NOVBOX $NOVAGRANT $NOPIP $NOANSIBLE $NOCOMPOSER (y/N)" choice1
[[ "$choice1" == [Yy]* ]] && sleep 2 || bash ~/adtalem-setup/setup-stack.sh

if [ "$NORUBY" == "Ruby" ]
then
echo -e "${BLUE}INSTALLING RUBY...${NC}"
xcode-select --install 2> /dev/null
echo -e "${GREEN}Ruby is installed.${NC}"
fi

if [ "$NOXCODE" == "Xcode" ]
then
echo -e "${BLUE}INSTALLING XCODE TOOLS...${NC}"
xcode-select --install 2> /dev/null
echo -e "${GREEN}XCODE TOOLS is installed.${NC}"
fi

if [ "$NOHOMEBREW" == "Homebrew" ]
then
echo -e "${BLUE}INSTALLING HOMEBREW...${NC}"
xcode-select --install 2> /dev/null
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask 2> /dev/null
brew install gnu-sed 2> /dev/null
brew analytics off 2> /dev/null
echo -e "\n"
echo -e "${GREEN}Homebrew is installed. ${NC}"
fi

if [ "$NOVBOX" == "Virtualbox" ]
then
echo -e "${BLUE}INSTALLING VIRTUALBOX...${NC}"
brew cask install virtualbox 2> /dev/null
echo -e "${GREEN}Virtualbox is installed.${NC}"
fi

if [ "$NOVAGRANT" == "Vagrant" ]
then
echo -e "${BLUE}INSTALLING VAGRANT...${NC}"
brew cask install vagrant 2> /dev/null
echo -e "${GREEN}Vagrant is installed. ${NC}"
fi

if [ "$NOPIP" == "Pip" ]
then
echo -e "${BLUE}INSTALLING PIP...${NC}"
sudo easy_install pip 2> /dev/null
echo -e "${GREEN}Pip has been installed.${NC}"
fi

if [ "$NOANSIBLE" == "Ansible" ]
then
sudo pip install ansible 2> /dev/null
echo -e "${GREEN}Ansible is installed.${NC}\n"
fi

if [ "$NOCOMPOSER" == "Composer" ]
then
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
mkdir ~/vms/CMS-Drupal-MKTG/vendor
mkdir ~/vms/CMS-Drupal-MKTG/vendor/bin
mv composer ~/vms/CMS-Drupal-MKTG/vendor/bin/
cd /usr/local/bin
rm -rf composer
ln -s ~/vms/CMS-Drupal-MKTG/vendor/bin/composer composer
fi

rm -rf ~/adtalem-setup/.setup_vars
# Install local environment
echo -e "${LIGHTBLUE}All required applications have been installed. ${NC}"
bash ~/adtalem-setup/setup-stack.sh

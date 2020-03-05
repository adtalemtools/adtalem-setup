#!/bin/bash
#
# Example shell script to run post-provisioning.
#
# This script adds some VM configuration and syncs the sites.

BASH_PROFILE_FILE=/home/vagrant/bash_profile
ACCESS_TOKEN_FILE=/home/vagrant/.setup_vars

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[1;96m'
LIGHTBLUE='\033[1;27m'
LIGHTERBLUE='\033[1;33m'
GRAY='\033[1;231m'
BOLD='\033[1;0m'
NC='\033[0m'

# Check to see if we've already performed this setup.
if [ ! -e "$BASH_PROFILE_FILE" ]; then
  # Have the user enter their Github token.
  # read -p "$(echo -e $LIGHTERBLUE"Enter your ATGE Github access token "$NC"(from https://github.com/settings/tokens): ")" MYGITTOKEN
if [ -e "$ACCESS_TOKEN_FILE" ]; then
source ~/.setup_vars
echo -e "${BLUE}\nADDING GITHUB ACCESS TOKEN TO VM${NC}"
  # Add the user's Github token.
  composer config -g github-oauth.github.com "$MYGITTOKEN"
  echo -e "${GREEN}Your Github access token has been added to the VM.${NC}"
  sleep 3
fi
echo -e "${BLUE}\nREFRESHING AND SYNCING LOCAL SITES${NC}"

  # Recreate site aliases.
  blt recipes:aliases:init:acquia

  # Run the refresh script.
  bash scripts/refresh-local.sh
  blt adtalem:sync:all
  echo -e "${GREEN}The sites have been synced.${NC}"
  sleep 3
  
  # Open the dashboard in Safari.
   open -a safari http://dashboard.adtalem-ecom.local

  # Remove the active bash_profile
  mv /home/vagrant/.bash_profile /home/vagrant/bash_profile
  source ~/.profile

  # Completion messages.
  echo -e "${YELLOW}Your local development VM has been setup.${NC}"
  echo -e "${YELLOW}Completed: "`date`"${NC}"

else
  echo -e "${YELLOW}Your local development VM has already been setup.${NC}"
  echo -e "${YELLOW}Completed: "`date`"${NC}"
  sleep 3
  exit 0
fi

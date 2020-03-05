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
echo -e "${BLUE}ATGE Local Development Setup for Mac v1.2${NC}"
echo -e "${LIGHTBLUE}Started: "`date`"${NC}\n"
sleep 1


options=("CMS-Drupal-MKTG" "CMS-Drupal-ECOM" "Check-Required-Apps")
select stack in "${options[@]}"; do
    SAVEDSTACK='MYSTACK="'$stack'"'
    echo $SAVEDSTACK >> ~/CMS-Drupal-Setup-Scripts/.setup_vars;
  case "$stack,$REPLY" in
    CMS-Drupal-MKTG,*|*,CMS-Drupal-MKTG)     bash ~/CMS-Drupal-Setup-Scripts/setup-local-mktg.sh; break ;;
    CMS-Drupal-ECOM,*|*,CMS-Drupal-ECOM)     bash ~/CMS-Drupal-Setup-Scripts/setup-local-ecom.sh; break ;;
    Check-Required-Apps,*|*,Check-Required-Apps)     bash ~/CMS-Drupal-Setup-Scripts/setup-apps.sh; break ;;
  esac
done

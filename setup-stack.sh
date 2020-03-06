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
echo -e "${LIGHTERBLUE}SELECT AN ATGE DEVELOPMENT STACK:${NC}"
sleep 1

options=("CMS-Drupal-MKTG" "CMS-Drupal-ECOM")
select stack in "${options[@]}"; do
    SAVEDSTACK='MYSTACK="'$stack'"'
    echo $SAVEDSTACK >> ~/adtalem-setup/.setup_vars;
  case "$stack,$REPLY" in
    CMS-Drupal-MKTG,*|*,CMS-Drupal-MKTG)     bash ~/adtalem-setup/setup-local-mktg.sh; break ;;
    CMS-Drupal-ECOM,*|*,CMS-Drupal-ECOM)     bash ~/adtalem-setup/setup-local-ecom.sh; break ;;
  esac
done

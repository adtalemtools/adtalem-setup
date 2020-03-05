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
echo -e "${BLUE}ATGE MKTG Local Development Refresh v1.2${NC}"
echo -e "${LIGHTBLUE}Started: "`date`"${NC}\n"
sleep 1

echo -e "${BLUE}WOULD YOU LIKE TO SYNC OR RELOAD? ${NC}\n"
echo -e "${LIGHTBLUE}Select SYNC to refresh local site data only, select RELOAD to rebuild your VM.${NC}"

options=("SYNC" "REBUILD")
select refresh in "${options[@]}"; do
    REFRESHTYPE='MYREFRESH="'$reftype'"'
    echo $REFRESHTYPE >> ~/CMS-Drupal-Setup-Scripts/.setup_vars;
  case "$reftype,$REPLY" in
    SYNC,*|*,SYNC)     bash ~/CMS-Drupal-Setup-Scripts/refresh-sync-vm.sh; break ;;
    REBUILD,*|*,REBUILD)     bash ~/CMS-Drupal-Setup-Scripts/refresh-reload-vm.sh; break ;;
  esac
done

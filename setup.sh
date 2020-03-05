#!/bin/bash
cp ~/setup-scripts/Setup\ Local\ Environment.command ~/Desktop/Setup\ Local\ Environment

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[1;96m'
LIGHTBLUE='\033[1;27m'
LIGHTERBLUE='\033[1;33m'
GRAY='\033[1;231m'
BOLD='\033[1;0m'
NC='\033[0m'

rm -rf ~/CMS-Drupal-Setup-Scripts/.setup_vars
bash ~/CMS-Drupal-Setup-Scripts/setup-switch.sh

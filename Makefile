SHELL=/bin/bash

# CREDIT - Colour pulled from https://gist.github.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9

# to see all colors, run
# bash -c 'for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done'
# the first 15 entries are the 8-bit colors

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

# set target color
TARGET_COLOR := $(BLUE)

POUND = \#

.DEFAULT_GOAL := help

PLAYBOOK = desktoperator.yaml

install: ## install software dependencies
	@echo "${BLUE}installing software dependencies ${RESET}"
	@sudo apt update
	@sudo apt install git ansible -y
	@echo "${BLUE}installing playbook dependencies ${RESET}"
	@ansible-galaxy install -r requirements.yaml --ignore-errors --force
run: ## run all ansible tasks
	@echo "${BLUE}running all ansible tasks${RESET}"
	@ansible-playbook --ask-become-pass --ask-vault-pass --connection=local "${PLAYBOOK}"
testpb: ## run all ansible tasks in test PB
	@echo "${BLUE}running all ansible tasks in test PB${RESET}"
	@ansible-playbook --ask-become-pass --ask-vault-pass --connection=local testpb.yaml
no_api: ## run all ansible tasks without making api calls
	@echo "${BLUE}running all ansible tasks: ${YELLOW}without the github tag${RESET}"
	@ansible-playbook --ask-become-pass --ask-vault-pass --connection=local --skip-tags "github" "${PLAYBOOK}"
no_regolith: ## run all ansible tasks without regolith cfg
	@echo "${BLUE}running all ansible tasks: ${YELLOW}without the regolith tag${RESET}"
	@ansible-playbook --ask-become-pass --ask-vault-pass --connection=local --skip-tags "regolith" "${PLAYBOOK}"
fast: ## run all ansible tasks without long running tasks
	@echo "${BLUE}running all ansible tasks: ${YELLOW}without the github or snap tag${RESET}"
	@echo "${YELLOW}Snaps are self updating, and GITHUB has an API limit.${RESET}"
	@ansible-playbook --ask-become-pass --ask-vault-pass --connection=local --skip-tags "github,snap,protonup" "${PLAYBOOK}"
test: ## run the playbook for a single tag: `make test TAG=[tag]` (case sensitive)
	@echo "${BLUE}testing ansible tag ${TAG} ${RESET}"
	@ansible-playbook --ask-become-pass --ask-vault-pass --connection=local --tags "${TAG}" "${PLAYBOOK}"
see_tags: ## run to see which tags are in use in the playbook
	@echo "${BLUE}retreived ansible tags ${RESET}"
	@grep -R 'tags:' . | grep -v '#' | less
help:
	@echo ""
	@echo "    ${BLACK}:: ${RED}Makefile Help${RESET} ${BLACK}::${RESET}"
	@echo ""
	@echo "Available options are:"
	@echo "-----------------------------------------------------------------${RESET}"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "${TARGET_COLOR}%-30s${RESET} %s\n", $$1, $$2}'

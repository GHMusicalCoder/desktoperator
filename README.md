# Desktoperator

## Status

Work in progress. Not all commits have been completed.

## Usage

* `git clone` this apt_repository
* install the `make` command with `sudo apt install make -y`
* run `make install` to install the software dependencies and ansible requirements
* Run either:
    * run `make run` to run the full playbook.
    * run `make test TAG=[tag name]` to filter tasks based on Ansible tags.
* run `make` to see the available options

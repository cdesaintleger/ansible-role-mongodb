# Check docker prerequites is OK
check-docker-prerequisites:
ifeq (, $(shell which docker))
	$(error "No docker in $(PATH), consider install docker package")
endif

# Check vagrant prerequites is OK
check-vagrant-prerequisites:
ifeq (, $(shell which vagrant))
	$(error "No vagrant in $(PATH), consider install vagrant package")
endif


# Get or set SSH vars
check-ssh-vars:
SSH_PRIVATE_KEY ?= $(HOME)/.ssh/id_rsa
SSH_PUBLIC_KEY ?= $(HOME)/.ssh/id_rsa.pub


# Clean all
clean: clean-test clean-pyc


# Clean test environments
clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr reports/


# Clean python files
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +


# Target used to execute tests on all tox environments
test-docker: check-docker-prerequisites check-ssh-vars
test-docker: export SSH_PRIVATE_KEY_PATH = $(SSH_PRIVATE_KEY)
test-docker: export SSH_PUBLIC_KEY_PATH = $(SSH_PUBLIC_KEY)
test-docker:
	tox


# Target used to execute tests on one tox environment
test-env: check-docker-prerequisites check-ssh-vars
test-env: export SSH_PRIVATE_KEY_PATH = $(SSH_PRIVATE_KEY)
test-env: export SSH_PUBLIC_KEY_PATH = $(SSH_PUBLIC_KEY)
test-env:
ifndef TOXENV
	$(error TOXENV is undefined)
endif
	tox -e "${TOXENV}"


test-vagrant: check-vagrant-prerequisites
test-vagrant:
	ANSIBLE_ROLES_PATH=../ vagrant up
	ANSIBLE_ROLES_PATH=../ vagrant provision
	vagrant ssh-config > .vagrant/ssh-config
	MONGODB_EDITION=org testinfra --hosts=mongodb-org-trusty --ssh-config=.vagrant/ssh-config --noconftest --sudo
	MONGODB_EDITION=org testinfra --hosts=mongodb-org-xenial --ssh-config=.vagrant/ssh-config --noconftest --sudo
	MONGODB_EDITION=enterprise testinfra --hosts=mongodb-ent-trusty --ssh-config=.vagrant/ssh-config --noconftest --sudo
	MONGODB_EDITION=enterprise testinfra --hosts=mongodb-ent-xenial --ssh-config=.vagrant/ssh-config --noconftest --sudo

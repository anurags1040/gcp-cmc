SHELL:=/bin/bash
.ONESHELL:
.SHELLFLAGS=-ec
.DEFAULT_GOAL:=default

CURRENT_TF_WORKSPACE=$(shell terraform workspace show)
TERRAFORM_VERSION=1.2.1

COMMAND=docker run -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/application_default_credentials.json -it -w /data/regions/cad -v $$(pwd)/../..:/data -v $${HOME}/.config/gcloud/application_default_credentials.json:/tmp/application_default_credentials.json:ro hashicorp/terraform:$(TERRAFORM_VERSION)

init:
	$(COMMAND) init

plan:
	$(COMMAND) plan -out=terraform.tfplan

apply:
	$(COMMAND) apply

execute:
	$(COMMAND) apply -auto-approve terraform.tfplan

destroy:
	$(COMMAND) destroy
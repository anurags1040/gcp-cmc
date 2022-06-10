SHELL:=/bin/bash
.ONESHELL:
.SHELLFLAGS=-ec
.DEFAULT_GOAL:=default

COMMAND=docker run -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/application_default_credentials.json -it -w /data/testing/networking -v $$(pwd)/../..:/data -v /Users/slew/.config/gcloud/application_default_credentials.json:/tmp/application_default_credentials.json:ro hashicorp/terraform:0.13.6

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
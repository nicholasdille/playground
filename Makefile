include .env.mk

NAME := playground
TF   := terraform

.PHONY:
clean:
	@rm -rf plan.out terraform.tfstate* ssh ssh.pub .terraform*

.PHONY:
show:
	@terraform show

.PHONY:
output:
	@terraform output

.PHONY:
init: .terraform.lock.hcl

.PHONY:
init-reconfigure:
	@\
	$(TF) init -reconfigure

.PHONY:
init-migrate-state:
	@\
	$(TF) init -migrate-state

.terraform.lock.hcl: *.tf
	@\
	$(TF) init -upgrade

.PHONY:
plan: plan.out

plan.out: *.tf .terraform.lock.hcl
	@\
	$(TF) plan \
		-out=plan.out \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"

.PHONY:
apply: plan.out
	@\
	$(TF) apply -auto-approve -state=terraform.tfstate plan.out
	@rm -f plan.out

.PHONY:
destroy:
	@\
	$(TF) destroy \
		-auto-approve \
		-state=terraform.tfstate \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"
	@rm -f terraform.tfstate*

.PHONY:
uniget:
	@packer init uniget.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build uniget.pkr.hcl

.PHONY:
docker:
	@packer init docker.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build docker.pkr.hcl

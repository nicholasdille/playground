include .env.mk

TF     := terraform
PACKER := packer

.PHONY:
clean: ## Remove all generated files
	@rm -rf .terraform.lock.hcl plan.out terraform.tfstate*

.PHONY:
clean-all: clean ## Remove all generated files and terraform cache
	@rm -rf .terraform

.PHONY:
lint: ## Format terraform files
	@$(TF) fmt \
		-diff=true \
		-check

.PHONY:
fmt: ## Format terraform files
	@$(TF) fmt

.PHONY:
show: ## Show terraform state
	@$(TF) show

.PHONY:
output:
	@$(TF) output

.PHONY:
validate: *.tf init ## Validate terraform files
	@$(TF) validate

.PHONY:
init: .terraform.lock.hcl ## Initialize terraform

.terraform.lock.hcl: *.tf
	@$(TF) init

.PHONY:
plan: plan.out ## Plan terraform

plan.out: validate .terraform.lock.hcl
	@$(TF) plan \
		-out=plan.out \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"

.PHONY:
apply: plan.out ## Apply terraform
	@$(TF) apply \
		-auto-approve \
		plan.out

.PHONY:
refresh: ## Refresh terraform state
	@$(TF) refresh \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"

.PHONY:
destroy: ## Destroy terraform
	@$(TF) destroy \
		-auto-approve \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"

.PHONY:
image: uniget docker ## Build image

.PHONY:
uniget: ## Build uniget image
	@$(PACKER) init uniget.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build uniget.pkr.hcl

.PHONY:
docker: ## Build docker image
	@$(PACKER) init docker.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build docker.pkr.hcl

.PHONY:
help:
	@echo "Usage: make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sed -E 's/^(.+): ([^#]+)?##\s*(.+)$$/\1 \3/' | column --table --table-columns-limit 2
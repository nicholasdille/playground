#!/bin/bash
set -o errexit

# renovate: datasource=gitlab-releases depName=gitlab-org/terraform-images
GITLAB_TERRAFORM_VERSION=1.8.0

curl -sSLfo "gitlab-terraform" \
    "https://gitlab.com/gitlab-org/terraform-images/-/raw/v${GITLAB_TERRAFORM_VERSION}/src/bin/gitlab-terraform.sh"
chmod +x gitlab-terraform

export CI_API_V4_URL="https://gitlab.com/api/v4"
export CI_PROJECT_ID=55776857
export TF_STATE_NAME=minecraft
export TF_HTTP_PASSWORD="$(pp gitlabcom-minecraft)"
export TF_USERNAME="$(curl -sSLfH "Private-Token: ${TF_PASSWORD}" https://gitlab.com/api/v4/user | jq -r .username)"

export TF_VAR_hcloud_token="$(pp hcloud-web)"
export TF_VAR_hetznerdns_token="$(pp hetzner-dns-web)"

./gitlab-terraform fmt

./gitlab-terraform init
./gitlab-terraform validate
./gitlab-terraform plan
./gitlab-terraform apply

#./gitlab-terraform init
#./gitlab-terraform destroy

#!/bin/bash
set -o errexit

# renovate: datasource=gitlab-releases depName=components/opentofu
GITLAB_TOFU_VERSION=0.50.0

curl -sSLfo "gitlab-tofu" \
    "https://gitlab.com/components/opentofu/-/raw/${GITLAB_TOFU_VERSION}/src/gitlab-tofu.sh"
chmod +x gitlab-tofu

export CI_API_V4_URL="https://gitlab.com/api/v4"
export CI_PROJECT_ID=55776857
export GITLAB_TOFU_STATE_NAME=minecraft
export TF_HTTP_PASSWORD="$(pp gitlabcom-minecraft)"
export TF_HTTP_USERNAME="$(curl -sSLfH "Private-Token: ${TF_HTTP_PASSWORD}" https://gitlab.com/api/v4/user | jq -r .username)"

export HCLOUD_TOKEN="$(pp hcloud-web)"
export TF_VAR_hcloud_token="${HCLOUD_TOKEN}"
export TF_VAR_hetznerdns_token="$(pp hetzner-dns-web)"

./gitlab-tofu fmt

./gitlab-tofu init
./gitlab-tofu validate
./gitlab-tofu plan
./gitlab-tofu apply

#./gitlab-tofu init
#./gitlab-tofu destroy

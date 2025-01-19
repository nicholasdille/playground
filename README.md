# Rollout of playground VM

## Prerequisites

```shell
uniget install \
    packer \
    terraform
```

## Create images

```shell
make uniget
make docker
```

## Rollout infrastructure

```shell
make apply
```

## Optional resources

See `tls.tf.disabled`

## Untested resources

See `sshfp.tf.disabled`

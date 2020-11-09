#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
} >> /etc/ecs/ecs.config

start ecs

yum install -y amazon-efs-utils
yum install -y nfs-utils
mkdir -p /mnt/efs/fs1
{
    echo "${efs_id}:/ /mnt/efs/fs1 efs tls,_netdev"
} >> /etc/fstab

mount -a -t efs,nfs4 defaults

echo "Done"
#!/bin/bash
aws eks update-kubeconfig --name $CLUSTER_NAME
cat ~/.kube/config

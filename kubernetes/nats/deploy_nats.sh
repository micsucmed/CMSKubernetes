#!/bin/bash

echo "Add ingress controller"
kubectl get nodes

echo "Initialize cms-nats alias for our minions"
kubectl get nodes | grep minion | awk 'BEGIN{i=0}{print "openstack server set --property landb-alias=cms-nats--load-"i"- "$1""; i++}'

echo "Wait for cms-nats landb entry to appear..., press CTRL+C when you see them"
watch -d host cms-nats.cern.ch

echo "Deploy NATS"
kubectl apply -f https://github.com/nats-io/nats-operator/releases/latest/download/00-prereqs.yaml
kubectl apply -f https://github.com/nats-io/nats-operator/releases/latest/download/10-deployment.yaml
kubectl get crd

echo "Let's watch when nats crd's are created, invoke CTRL+C when you see them"
watch -d kubectl get crd | grep nats

kubectl apply -f nats-cluster.yaml --validate=false

echo "Now let's see if nats-cluster are Running..., press CTRL+C when you see them"
watch -d kubectl get nats --all-namespaces

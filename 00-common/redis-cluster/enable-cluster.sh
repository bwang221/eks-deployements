#!/bin/bash
# Find all ClusterIPs of  nodes
export REDIS_NODES=$(kubectl get pods  -l app=redis-cluster -n redis -o json | jq -r '.items | map(.status.podIP) | join(":6379 ")'):6379
echo $REDIS_NODES
# Activate the Redis cluster, a cluster requires minimum 6 nodes.
kubectl exec -it redis-cluster-0 -n redis -- redis-cli --cluster create  ${REDIS_NODES} --cluster-replicas 1
# Check, display role of each node
for x in $(seq 0 5); do echo "redis-cluster-$x"; kubectl exec redis-cluster-$x -n redis -- redis-cli role; echo; done
#!/usr/bin/env bash
trap "echo Error.  Likely cause is db cluster still being cloned. Can run '_7createDBInstance.sh' again later.; exit" ERR
clusterName=$(cat lastRDSClusterName.res | ../../tools/jsonX.sh clusterName)
echo "Creating DB Instance"
aws rds create-db-instance --db-instance-identifier roxydb2 --db-instance-class db.t2.small --engine aurora --db-cluster-identifier $clusterName > lastDBInstance.res
echo "Done Creating DB Instance"
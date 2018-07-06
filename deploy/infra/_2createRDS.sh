#!/usr/bin/env bash
trap "echo Error; exit" ERR
name_suffix=$(date +%s)
export sub1=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export sub2=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export sub3=$(cat lastSubNet3.res | ../../tools/jsonX.sh Subnet.SubnetId)
export DBSG_ID=$(cat lastDBSG.res | ../../tools/jsonX.sh GroupId)
echo "Creating DBSubNetGroup"
aws rds create-db-subnet-group --db-subnet-group-name roxyDBSubnetGroup"-"$name_suffix --subnet-ids $sub1 $sub2 $sub3 --db-subnet-group-description "script generated subnet group for rds clone" > lastDBSubNetGroup.res
echo "Cloning RDS"
DB_SUBNET_GROUP=$(cat lastDBSubNetGroup.res | ../../tools/jsonX.sh DBSubnetGroup.DBSubnetGroupName)
aws rds restore-db-cluster-to-point-in-time --use-latest-restorable-time --source-db-cluster-identifier $ROXY_BASE_RDS_CLUSTER_ID --db-cluster-identifier $ROXY_BASE_RDS_CLUSTER_ID"-"$name_suffix --restore-type copy-on-write --port $ROXY_BASE_RDS_PORT --db-subnet-group-name $DB_SUBNET_GROUP --vpc-security-group-ids $DBSG_ID > lastRDSClone.res
echo "{\"clusterName\": \""$ROXY_BASE_RDS_CLUSTER_ID"-"$name_suffix"\"}" > lastRDSClusterName.res
echo "Done cloning RDS. Instance will be created later."
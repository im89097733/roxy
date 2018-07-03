#!/usr/bin/env bash
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export SUBNET_1=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export SUBNET_2=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
echo killing subnets
aws ec2 delete-subnet --subnet-id $SUBNET_1
aws ec2 delete-subnet --subnet-id $SUBNET_2
echo killing the last VPC_ID=$VPC_ID
aws ec2 delete-vpc --vpc-id $VPC_ID
echo VPC_ID=$VPC_ID deleted
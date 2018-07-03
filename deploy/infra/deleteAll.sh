#!/usr/bin/env bash
#trap "echo Error; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export SUBNET_1=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export SUBNET_2=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export ASG_1=$(cat lastASG1.res | ../../tools/jsonX.sh ASGName)
export ASG_2=$(cat lastASG2.res | ../../tools/jsonX.sh ASGName)
echo "Killing ASGs"
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG_1 --force-delete
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG_2 --force-delete
echo "killing subnets"
aws ec2 delete-subnet --subnet-id $SUBNET_1
aws ec2 delete-subnet --subnet-id $SUBNET_2
echo "killing the VPC_ID="$VPC_ID
aws ec2 delete-vpc --vpc-id $VPC_ID
echo "VPC_ID="$VPC_ID" deleted"
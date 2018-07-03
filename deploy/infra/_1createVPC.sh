#!/usr/bin/env bash
trap "echo Error; exit" ERR
echo creating VPC with CIDR: $ROXY_BASE_VPC_CIDR and subnets
aws ec2 create-vpc --cidr-block $ROXY_BASE_VPC_CIDR > lastVPC.res
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
echo VPC_ID=$VPC_ID
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $ROXY_BASE_SUBNET1_CIDR --availability-zone $ROXY_BASE_REGION'a' > lastSubNet1.res
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $ROXY_BASE_SUBNET2_CIDR --availability-zone $ROXY_BASE_REGION'b' > lastSubNet2.res
echo completed VPC create.  see .res files
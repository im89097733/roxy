#!/usr/bin/env bash
trap "echo Likely problem is that ASG or ELB must terminate completely before killing VPC. try just the killVPC.sh again once the instances shutdown and the ASGs and ELB go away.  Or delete using console; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export SUBNET_1=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export SUBNET_2=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export SUBNET_3=$(cat lastSubNet3.res | ../../tools/jsonX.sh Subnet.SubnetId)
export IG_ID=$(cat lastIG.res | ../../tools/jsonX.sh InternetGateway.InternetGatewayId)
export ELBSG_ID=$(cat lastELBSG.res | ../../tools/jsonX.sh GroupId)
export EC2SG_ID=$(cat lastEC2SG.res | ../../tools/jsonX.sh GroupId)
export DBSG_ID=$(cat lastDBSG.res | ../../tools/jsonX.sh GroupId)
#TODO I think the main routing table needs to be deleted as well before the subnets can be removed
#TODO I also think the IG needs to be deleted before as well
echo "Dropping IG from VPC"
aws ec2 detach-internet-gateway --internet-gateway-id $IG_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IG_ID
echo "killing subnets"
aws ec2 delete-subnet --subnet-id $SUBNET_1
aws ec2 delete-subnet --subnet-id $SUBNET_2
aws ec2 delete-subnet --subnet-id $SUBNET_3
echo "Dropping security groups"
aws ec2 delete-security-group --group-id $DBSG_ID
aws ec2 delete-security-group --group-id $EC2SG_ID
aws ec2 delete-security-group --group-id $ELBSG_ID
echo "killing the VPC_ID="$VPC_ID
aws ec2 delete-vpc --vpc-id $VPC_ID
echo "VPC_ID="$VPC_ID" deleted"
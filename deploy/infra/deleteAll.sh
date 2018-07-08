#!/usr/bin/env bash
#trap "echo Likely problem is that ASGs already terminated. try just the killVPC.sh or delete using console; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export SUBNET_1=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export SUBNET_2=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export ASG_1=$(cat lastASG1.res | ../../tools/jsonX.sh ASGName)
export ASG_2=$(cat lastASG2.res | ../../tools/jsonX.sh ASGName)
export ELB_ARN=$(cat lastELB.res | ../../tools/jsonX.sh LoadBalancers.[0].LoadBalancerArn)
export TG_ARN=$(cat lastTG.res | ../../tools/jsonX.sh TargetGroups.[0].TargetGroupArn)
export LC_NAME=$(cat lastLC.res | ../../tools/jsonX.sh LCName)
echo "Starting kill ASGs"
./killASG.sh
echo "Starting kill ELB"
./killELB.sh
echo "Starting kill VPC"
./killVPC.sh
echo "Cleaning up orphaned TG and LC"
aws autoscaling delete-launch-configuration --launch-configuration-name $LC_NAME
aws elbv2 delete-target-group --target-group-arn $TG_ARN
echo "Done."
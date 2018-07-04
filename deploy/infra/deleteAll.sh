#!/usr/bin/env bash
trap "echo Likely problem is that ASGs already terminated. try just the killVPC.sh or delete using console; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export SUBNET_1=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export SUBNET_2=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export ASG_1=$(cat lastASG1.res | ../../tools/jsonX.sh ASGName)
export ASG_2=$(cat lastASG2.res | ../../tools/jsonX.sh ASGName)
export ELB_ARN=$(cat lastELB.res | ../../tools/jsonX.sh LoadBalancers.[0].LoadBalancerArn)
echo "Killing ASGs"
./killASG.sh
echo "Killing ELB"
./killELB.sh
echo "Killing VPC"
./killVPC.sh
echo "Done."
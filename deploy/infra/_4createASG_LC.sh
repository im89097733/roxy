#!/usr/bin/env bash
trap "echo Error; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export ZONE1_ID=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export ZONE2_ID=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export tg_arn=$(cat lastTG.res | ../../tools/jsonX.sh TargetGroups.[0].TargetGroupArn)
export sec_id=$(cat lastEC2SG.res | ../../tools/jsonX.sh GroupId)
name_suffix=$(date +%s)
lc_name='roxyLC-'$name_suffix
asg1_name='roxyASG1-'$name_suffix
asg2_name='roxyASG2-'$name_suffix
echo "creating new LC with name: "$lc_name
aws autoscaling create-launch-configuration --launch-configuration-name $lc_name --key-name $ROXY_BASE_KEYPAIR --image-id $ROXY_BASE_AMI --security-groups $sec_id --instance-type $ROXY_BASE_INSTANCE_TYPE
echo "{\"LCName\":\""$lc_name"\"}" > lastLC.res
echo "Creating new auto scaling groups.  "
# TODO handle reuse of existing ASG (lastASG)
#echo NOTE: specify 'reuseASG' to reuse existing ASGs"
echo "Creating ASG Zone 1 "$ZONE1_ID
aws autoscaling create-auto-scaling-group --auto-scaling-group-name $asg1_name --launch-configuration-name $lc_name  --min-size 1 --max-size 1 --vpc-zone-identifier $ZONE1_ID --target-group-arns $tg_arn
echo "{\"ASGName\":\""$asg1_name"\"}" > lastASG1.res
echo "Creating ASG Zone 2 "$ZONE2_ID
aws autoscaling create-auto-scaling-group --auto-scaling-group-name $asg2_name --launch-configuration-name $lc_name  --min-size 1 --max-size 1 --vpc-zone-identifier $ZONE2_ID --target-group-arns $tg_arn
echo "{\"ASGName\":\""$asg2_name"\"}" > lastASG2.res
echo "Done"
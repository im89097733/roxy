#!/usr/bin/env bash
trap "echo Error; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
export ZONE1_ID=$(cat lastSubNet1.res | ../../tools/jsonX.sh Subnet.SubnetId)
export ZONE2_ID=$(cat lastSubNet2.res | ../../tools/jsonX.sh Subnet.SubnetId)
export tg_arn=$(cat lastTG.res | ../../tools/jsonX.sh TargetGroups.[0].TargetGroupArn)
export sec_id=$(cat lastELBSG.res | ../../tools/jsonX.sh GroupId)
name_suffix=$(date +%s)
elb_name='roxyELB-'$name_suffix
echo "Creating ELB "$elb_name
aws elbv2 create-load-balancer --name $elb_name --security-groups $sec_id --subnets $ZONE2_ID $ZONE1_ID > lastELB.res
export lb_arn=$(cat lastELB.res | ../../tools/jsonX.sh LoadBalancers.[0].LoadBalancerArn)
echo "Created ELB->"$lb_arn
echo "Creating and binding Listener(s) to LB"
echo "HTTP"
aws elbv2 create-listener --load-balancer-arn $lb_arn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$tg_arn > lastHHTPListener.res
echo "Created HTTP listener"
echo "HTTPS"
aws elbv2 create-listener --load-balancer-arn $lb_arn --protocol HTTPS --port 443 --certificates CertificateArn=$ROXY_BASE_TRINIMBUS_ANDRESS_CERT_ARN --default-actions Type=forward,TargetGroupArn=$tg_arn > lastHHTPSListener.res
echo "Done."

#!/usr/bin/env bash
trap "echo Error; exit" ERR
name_suffix=$(date +%s)
echo "Creating VPC with CIDR: "$ROXY_BASE_VPC_CIDR" and subnets"
aws ec2 create-vpc --cidr-block $ROXY_BASE_VPC_CIDR > lastVPC.res
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
echo "VPC_ID="$VPC_ID
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $ROXY_BASE_SUBNET1_CIDR --availability-zone $ROXY_BASE_REGION'a' > lastSubNet1.res
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $ROXY_BASE_SUBNET2_CIDR --availability-zone $ROXY_BASE_REGION'b' > lastSubNet2.res
echo "Completed VPC create.  see .res files"
echo "Creating security group chain"
echo "Creating ELBSG"
elbsg_name='roxyELBSG-'$name_suffix
aws ec2 create-security-group --description "script generated elb security group for roxy" --group-name $elbsg_name --vpc-id $VPC_ID > lastELBSG.res
export ELBSG_ID=$(cat lastELBSG.res | ../../tools/jsonX.sh GroupId)
echo "Created ELBSG "$ELBSG_ID
echo "Opening ELBSG to the world on port 80"
aws ec2 authorize-security-group-ingress --group-id $ELBSG_ID --port 80 --protocol tcp --cidr 0.0.0.0/0 > lastELB80Ingress.res
echo "Opening ELBSG to the world on port 443"
aws ec2 authorize-security-group-ingress --group-id $ELBSG_ID --port 443 --protocol tcp --cidr 0.0.0.0/0 > lastELB443Ingress.res
echo "Creating EC2SG"
ec2sg_name='roxyEC2SG-'$name_suffix
aws ec2 create-security-group --description "script generated instance security group for roxy" --group-name $ec2sg_name --vpc-id $VPC_ID  > lastEC2SG.res
export EC2SG_ID=$(cat lastEC2SG.res | ../../tools/jsonX.sh GroupId)
echo "Created EC2SG "$EC2SG_ID
echo "Authorizing ingress for "$EC2SG_ID
aws ec2 authorize-security-group-ingress --group-id $EC2SG_ID --port 8080 --protocol tcp --source-group $ELBSG_ID > lastEC2Ingress.res
echo "Creating DBSG"
dbsg_name='roxyDBSG-'$name_suffix
aws ec2 create-security-group --description "script generated database security group for roxy" --group-name $dbsg_name --vpc-id $VPC_ID  > lastDBSG.res
export DBSG_ID=$(cat lastDBSG.res | ../../tools/jsonX.sh GroupId)
echo "Created DBSG for new RDS."$DBSG_ID
echo "Creating ingress for new RDS"
aws ec2 authorize-security-group-ingress --group-id $DBSG_ID --port 3306 --protocol tcp --source-group $EC2SG_ID > lastNewRDSIngress.res
echo "Creating Internet Gateway (IG)"
aws ec2 create-internet-gateway > lastIG.res
export IG_ID=$(cat lastIG.res | ../../tools/jsonX.sh InternetGateway.InternetGatewayId)
echo "Created IG "$IG_ID
echo "Binding IG to VPC"
aws ec2 attach-internet-gateway --internet-gateway-id $IG_ID --vpc-id $VPC_ID #> lastIGAttach.res
echo "Done. All new VPC."
echo "Attempting to add ingress on original RDS: "$ROXY_BASE_DBSG
aws ec2 authorize-security-group-ingress --group-id $ROXY_BASE_DBSG --port 3306 --protocol tcp --source-group $EC2SG_ID > lastBaseRDSIngress.res
echo "Done."

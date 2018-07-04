#!/usr/bin/env bash
echo "Patching route table for o/b ig"
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" > lastRoute.res
export ROUTE_TABLE_ID=$(cat lastRoute.res | ../../tools/jsonX.sh RouteTables.[0].RouteTableId)
export IG_ID=$(cat lastIG.res | ../../tools/jsonX.sh InternetGateway.InternetGatewayId)
echo "Adding internet egress to ROUTE_TABLE_ID "$ROUTE_TABLE_ID
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IG_ID
echo "Done Route Table Patch"
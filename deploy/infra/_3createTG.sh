#!/usr/bin/env bash
trap "echo Error; exit" ERR
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
name_suffix=$(date +%s)
group_name='roxyTG-'$name_suffix
hc_path="//RESTTest.html"
aws elbv2 create-target-group --name $group_name --target-type instance --protocol HTTP --health-check-protocol HTTP --vpc-id $VPC_ID --port 8080 --health-check-path $hc_path > lastTG.res
echo "createTG complete"
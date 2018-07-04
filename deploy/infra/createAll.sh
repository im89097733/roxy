#!/usr/bin/env bash
echo "Creating VPC, security, and other related"
./_1createVPC.sh

# echo "Creating DB in VPC"
# ./_2createRDS.sh

echo "Creating Target Group, and related"
./_3createTG.sh

echo "Creating LC, ASG, and related"
./_4createASG_LC.sh

echo "Creating ELB"
./_5createELB.sh

echo "Done."
export VPC_ID=$(cat lastVPC.res | ../../tools/jsonX.sh Vpc.VpcId)
echo "All infrastructure exists in VPC:"$VPC_ID
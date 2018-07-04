#!/usr/bin/env bash
aws elbv2 delete-load-balancer --load-balancer-arn $ELB_ARN
echo "ELB killed."
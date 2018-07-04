#!/usr/bin/env bash
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG_1 --force-delete
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG_2 --force-delete
echo "ASGs killed"
#!/usr/bin/env bash
aws ec2 create-image --cli-input-json file://_4input.json > _4.res
echo "Results are in _4.res.  The new AMI ID is used in deploying the app to infrastructure."
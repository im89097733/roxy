#!/usr/bin/env bash
aws ec2 run-instances --cli-input-json file://_1input.json > _1.res
echo "Results are in _1.res.  You can now remote into this server to make modifications and test.  When ready run _4newAMIFromInstance.sh after modifying the file _4input.json with this instanceid."
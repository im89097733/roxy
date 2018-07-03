#!/usr/bin/env bash

# setup your shell by running '. ./setenv.sh' on the cli prompt
echo JAVA_HOME: $JAVA_HOME
echo HOME: $HOME

export  ROXY_HOME=$(pwd)
export  ROXY_BASE_REGION="us-east-1"
export  ROXY_BASE_AMI="ami-e9dd8596"
export  ROXY_BASE_EC2SG="sg-5098021b"
export  ROXY_BASE_ELBSG="sg-2a533661"
export  ROXY_BASE_DBSG="sg-e6e478ad"

echo ROXY_HOME: $ROXY_HOME
echo ROXY_BASE_REGION: $ROXY_BASE_REGION
echo ROXY_BASE_AMI: $ROXY_BASE_AMI
echo ROXY_BASE_EC2SG: $ROXY_BASE_EC2SG
echo ROXY_BASE_ELBSG: $ROXY_BASE_ELBSG
echo ROXY_BASE_DBSG: $ROXY_BASE_DBSG


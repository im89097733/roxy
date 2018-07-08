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
export  ROXY_BASE_KEYPAIR="roxyKeyPair"
export  ROXY_BASE_INSTANCE_TYPE="t2.micro"
export  ROXY_BASE_VPC_CIDR="10.0.0.0/16"
export  ROXY_BASE_SUBNET1_CIDR="10.0.1.0/24"
export  ROXY_BASE_SUBNET2_CIDR="10.0.2.0/24"
export  ROXY_BASE_SUBNET3_CIDR="10.0.3.0/24"
export  ROXY_BASE_SUBNET4_CIDR="10.0.4.0/24"
export  ROXY_BASE_RDS_PORT=3306
export  ROXY_BASE_RDS_CLUSTER_ID="roxydb-cluster"
export  ROXY_BASE_RDS_INSTANCE_ID="roxydb"
export  ROXY_BASE_TRINIMBUS_ANDRESS_CERT_ARN="arn:aws:iam::272462672480:server-certificate/roxyCert"


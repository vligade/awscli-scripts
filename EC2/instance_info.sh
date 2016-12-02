#aws_access_key_id =AKIAJGLQUETH2WYI4YWQ
#aws_secret_access_key =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
#region=US-East-1
#outpu=json

#start the instance
#aws ec2 start-instances --instance-ids i-fe0c8917

#!/bin/sh
############################################################################################################################
#   Name                :  aws_cli.sh         ::          Alias:System Info                                                #
#   Purpose             :  Script for gathering ec2 instance information                                                   #
#   Author              :       Cloud Techops :: 			Last modified by: Prateek Malik    ::   ver 1.1                #
############################################################################################################################
NOW=$(date +"%b%Y")
LOG_DIR="/var/log/patching/$NOW"
EC2_DIR="$LOG_DIR/EC2_info"
INSTANCE_STATE="$EC2_DIR/instance_state.log"
INSTANCE_VPC="$EC2_DIR/vpc.log"
INSTANCE_ID="$EC2_DIR/instance_id.log"
INSTANCE_SUBNET="$EC2_DIR/subnet_id.log"
INSTANCE_SECGRP="$EC2_DIR/security_group.log"

TEMP_DIR="/tmp/"
TEMP_FILE="$LOG_DIR/temp_aws.dat"

# Verifying Directories
if [ ! -d $EC2_DIR ]; then
mkdir -p $EC2_DIR
echo "$EC2_DIR log directory doesn't exists , directory created" 
fi
if [ ! -d $LOG_DIR ]; then
mkdir -p $LOG_DIR
echo "$LOG_DIR log directory doesn't exists , directory created" 
fi
if [ ! -d $TEMP_DIR ]; then
mkdir -p $TEMP_DIR
echo "$TEMP_DIR temp directory doesn't exists , directory created"
fi
# Intializing log files
> $TEMP_FILE
> $INSTANCE_STATE
> $INSTANCE_VPC
> $INSTANCE_ID
> $INSTANCE_SUBNET
> $INSTANCE_SECGRP


cat /etc/ec2_id > $TEMP_FILE
input="$TEMP_FILE"
while IFS= read -r var
	do
		aws ec2 describe-instances --instance-ids $var --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text >> $INSTANCE_STATE 
		aws ec2 describe-instances --instance-ids $var --query 'Reservations[*].Instances[*].[InstanceId, VpcId]' --output text >> $INSTANCE_VPC 
		aws ec2 describe-instances --instance-ids $var --query 'Reservations[*].Instances[*].[InstanceId]' --output text >> $INSTANCE_ID
		aws ec2 describe-instances --instance-ids $var --query 'Reservations[*].Instances[*].[InstanceId, SubnetId]' --output text >> $INSTANCE_SUBNET 
		aws ec2 describe-instances --instance-ids $var --query 'Reservations[*].Instances[*].[InstanceId,SecurityGroups[*].GroupId]' --output text >> $INSTANCE_SECGRP
	done < "$input"

	
#aws ec2 describe-instances --instance-ids i-fe0c8917 --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text


#!/bin/bash

current=`date +"%d%b%Y"_"%H%M%S"`
echo "Now Script will be making AMIs & tagging the AMIs According to the Instance Tags"

instanceName=`/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$1" "Name=key,Values=Name" --query 'Tags[].Value' --output text`
ImageId=($(/usr/local/bin/aws ec2 create-image --no-reboot --instance-id $1 --name "$instanceName $current" --description "This image was created on $current by user from instance $1" --output text))
keys=($(/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$1" --query 'Tags[].[Key]' --output text))
                for j in "${keys[@]}"
                do
                         value=`/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$1" "Name=key,Values=$j" --query 'Tags[].Value' --output text`
                         echo $value
			 	/usr/local/bin/aws ec2 create-tags --resources $ImageId --tags Key=$j,Value=$value
                done

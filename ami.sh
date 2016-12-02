#!/bin/bash

current=`date +%F`
echo "Now Script will be making AMIs & tagging the AMIs According to the Instance Tags" 
function create_image ()
{
#Fetch instance ids of running instances
var=($(/usr/local/bin/aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId]' --filters "Name=instance-state-name,Values=running" --output text))

for i in "${var[@]}"
do
	#Name-Tag of the instance
	instanceName=`/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$i" "Name=key,Values=Name" --query 'Tags[].Value' --output text`
       	
	ImageId=($(/usr/local/bin/aws ec2 create-image --no-reboot --instance-id $i --name "$instanceName $current" --description "This image was created on $current by user from instance $i" --output text))
     
      	keys=($(/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$i" --query 'Tags[].[Key]' --output text))

                for j in "${keys[@]}"
                do

                         value=`/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$i" "Name=key,Values=$j" --query 'Tags[].Value' --output text`
                         echo $value
			 /usr/local/bin/aws ec2 create-tags --resources $ImageId --tags Key=$j,Value=$value
                done

done	
}

function delete_ami ()
{
	var=($(aws ec2 describe-images --owners self --query 'Images[*].ImageId' --output text))

	for i in "${var[@]}" 
	do
	
	aws ec2 describe-images --owners self --image-id $i --query 'Images[*].Description' --output text | grep "This image was created"

	if [ $? -eq 0 ];then

		char=($(aws ec2 describe-images --owners self --image-id $i --query 'Images[*].Description' --output text | awk '{print $6}')) 

        	if [ `date -d "$char" +%s` -lt `date --date="15 days ago" +%s` ]; then
			echo "This image is older than one month and will be deleted!!  Image ID : $i"
          		aws ec2 deregister-image --image-id $i
      		else
          		echo "This image was created less than 30 days ago and will not be deleted!! Image ID : $i"
    		fi

	
	fi


    	done
}
create_image
delete_ami


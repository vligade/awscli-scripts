#Generate a report with groups, users and roles (Security Credentials / Groups)
#For group (Admin,Master)the member list is provided

#!/bin/sh
#Month and Year : Date
M_NOW=$(date +"%b%Y")
LOG_DIR="/var/log/aws_cli"
#List all AWS Users monthly
AWS_USERS="$LOG_DIR/aws_users-$M_NOW.log"
#Monthly Status of AWS USER ROLES
AWS_USERS_ROLES="$LOG_DIR/user-roles-$M_NOW.log"
# Verifying Directories
if [ ! -d $LOG_DIR ]; then
mkdir -p $LOG_DIR
echo "$LOG_DIR log directory doesn't exists , directory created" 
fi
# Intializing log files
> $AWS_USERS
> $AWS_USERS_ROLES

#List all users
echo " ========== AWS IAM USER GROUPS ASSIGNED ==========" >> $AWS_USERS_ROLES
aws iam list-users --query 'Users[*].[UserName]' --output text >> $AWS_USERS                                                                                                                                                                                             
input="$AWS_USERS"
while IFS= read -r var
	do
		echo " " >> $AWS_USERS_ROLES
		echo "User Name        |         Groups Assigned">> $AWS_USERS_ROLES
		echo -e "$var\t\t" `aws iam list-groups-for-user --user-name $var --query 'Groups[*].[GroupName]' --output text` >> $AWS_USERS_ROLES 
	done < "$input"
echo -e "\n=====================================================\n" >> $AWS_USERS_ROLES
echo "AWS Users with MASTER Access :" >> $AWS_USERS_ROLES
aws iam get-group --group-name Master --query 'Users[*].[UserName]' --output text >> $AWS_USERS_ROLES	
echo "AWS Users with ADMIN Access :" >> $AWS_USERS_ROLES
aws iam get-group --group-name ADMIN --query 'Users[*].[UserName]' --output text >> $AWS_USERS_ROLES
echo -e  Hello,'\n''\n'Please find the attached AWS IAM-User-Roles Report for US-East1 region.'\n''\n' | mail -s “AWS-IAM-USER-ROLES-LIST” -a $AWS_USERS_ROLES -r cloud.infra.us@axway.com prmalik@axway.com -c schandrasekaran@axway.com , abkumar@axway.com , tcrowder@axway.com 

#echo | mail -s "IPADDR $FQDN has started after reboot " -r  cloud.infra.us@axway.com prmalik@axway.com

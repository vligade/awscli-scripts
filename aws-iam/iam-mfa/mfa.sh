#Email the report of human users with mfa disabled
#!/bin/sh
LOG_DIR="/var/log/aws_cli"
#List all AWS Human Users
AWS_HUSERS="$LOG_DIR/aws_humanusers.log"
MFA_STATUS="$LOG_DIR/mfa_status.log"
# Verifying Directories
if [ ! -d $LOG_DIR ]; then
mkdir -p $LOG_DIR
echo "$LOG_DIR log directory doesn't exists , directory created" 
fi
# Intializing log files
> $AWS_HUSERS
> $MFA_STATUS

echo "MFA is disabled for the following users:" >> $MFA_STATUS
#List all human users
aws iam get-group --group-name HumanUser --query 'Users[*].[UserName]' --output text >> $AWS_HUSERS                                                                                                                                                                                             
input="$AWS_HUSERS"
while IFS= read -r var
	do
		MFA_SKEY=`aws iam list-mfa-devices --user-name $var --query 'MFADevices[*].[SerialNumber]' --output text`
		if [ "$MFA_SKEY" = "" ]; then
				echo "$var" >> $MFA_STATUS
		fi 
	done < "$input"
echo -e  Hello,'\n''\n'Please find the attached AWS MFA Status for US-East1 region.'\n''\n' | mail -s “AWS-MFA-STATUS” -a $MFA_STATUS -r cloud.infra.us@company_name.com prmalik@company_name.com


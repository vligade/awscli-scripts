#Access-Key IAM information
#!/bin/sh
LOG_DIR="/var/log/aws_cli"
AWS_USERS="$LOG_DIR/aws_users.log"
AWS_HUMAN_USERS="$LOG_DIR/aws_human_users.log"
ACCESSKEY_STATUS="$LOG_DIR/access-keys-status.log"
ACCESSKEY_CDATE="$LOG_DIR/access-keys-cdate.log"
#Monthly Status of AWS Logs
ACCESSKEY_LIST="$LOG_DIR/access-keys-list.log"

# Verifying Directories
if [ ! -d $LOG_DIR ]; then
mkdir -p $LOG_DIR
echo "$LOG_DIR log directory doesn't exists , directory created" 
fi

# Intializing log files
> $AWS_USERS
> $ACCESSKEY_STATUS
> $ACCESSKEY_LIST
> $ACCESSKEY_CDATE
> $AWS_HUMAN_USERS

#List all users and check access key for all of them.
aws iam list-users --query 'Users[*].[UserName]' --output text >> $AWS_USERS      
echo -e " ============ AWS IAM ACCESSKEY STATUS ============\n" >> $ACCESSKEY_LIST                                                                                                                                                                                      
input="$AWS_USERS"
while IFS= read -r var
	do
		echo -e "---------------------------------------\nACCESSKEY_STATUS	|	"$var"\n----------------------------------------" >> $ACCESSKEY_LIST
		aws iam list-access-keys --user-name $var --query 'AccessKeyMetadata[*].[Status]' --output text > $ACCESSKEY_STATUS
		count_temp=`cat $ACCESSKEY_STATUS | wc -l`
		if [[ $count_temp > 1 ]]; then 
		{
			if [ "`cat $ACCESSKEY_STATUS | grep -i Active`" != "" ];
			then
			{
				echo "Active : $var" >> $ACCESSKEY_LIST
				aws iam list-access-keys --user-name $var --query 'AccessKeyMetadata[*].[CreateDate]' --output text > $ACCESSKEY_CDATE                                                                                                                                                                                        
				for (( j=1; j <= $count_temp; j++ ))
				do
					temp_cdate=`cat $ACCESSKEY_CDATE | sed -n "$j"p | rev | cut -c11- | cut -d" " -f1 | rev`
					echo "Creation Date : $temp_cdate" >> $ACCESSKEY_LIST
					ACCESSKEY_EDATE=`date -d "$temp_cdate + 365 days" +%Y-%m-%d`
					echo "Expiration Date : $ACCESSKEY_EDATE" >> $ACCESSKEY_LIST
					#System_Date
					A_NOW=$(date +"%Y-%m-%d")
					#echo $A_NOW
					if [[ "$A_NOW" > "$ACCESSKEY_EDATE" ]]; then
					{
						echo 'ACTION : ACCESSKEY NEEDS TO BE ROTATED' >> $ACCESSKEY_LIST
						echo -e "You have been recognized as having a US-East1 AWS Service Account - "$var".Access Key for this Service Account has been expired.If you still require access key for this account. \n1) Please respond back to this message immediately \n2) Login to the account as soon as possible and rotate the access keys for the account.\nIf you fail to change the access key within the next 7 business days, an Access Request will opened to terminate the access." | mail -s "US-East1 AWS Access Key Expired" -r cloud.infra.us@company_name.com prmalik@company_name.com
					}
					else
						echo "No Action required" >> $ACCESSKEY_LIST
					fi
				done	
			}
			else
				echo "Not Active" >> $ACCESSKEY_LIST
			fi
		}	
		else
		{	
			if [ "`cat $ACCESSKEY_STATUS`" = "Active" ];
			then
			{
				echo "Active" >> $ACCESSKEY_LIST
				aws iam list-access-keys --user-name $var --query 'AccessKeyMetadata[*].[CreateDate]' --output text > $ACCESSKEY_CDATE                                                                                                                                                                                        
				temp_cdate=`cat $ACCESSKEY_CDATE | rev | cut -c11- | cut -d" " -f1 | rev`
				echo "Creation Date : $temp_cdate" >> $ACCESSKEY_LIST
				ACCESSKEY_EDATE=`date -d "$temp_cdate + 365 days" +%Y-%m-%d`
				echo "Expiration Date : $ACCESSKEY_EDATE" >> $ACCESSKEY_LIST
				#System_Date
				A_NOW=$(date +"%Y-%m-%d")
				#echo $A_NOW
				if [[ "$A_NOW" > "$ACCESSKEY_EDATE" ]]; then
				{
					echo 'ACTION : ACCESSKEY NEEDS TO BE ROTATED' >> $ACCESSKEY_LIST
					echo -e "You have been recognized as having a US-East1 AWS Service Account - "$var".Access Key for this Service Account has been expired.If you still require access key for this account. \n1) Please respond back to this message immediately \n2) Login to the account as soon as possible and rotate the access keys for the account.\nIf you fail to change the access key within the next 7 business days, an Access Request will opened to terminate the access." | mail -s "US-East1 AWS Access Key Expired" -r cloud.infra.us@company_name.com prmalik@company_name.com
				}
				else
					echo "No Action required" >> $ACCESSKEY_LIST
				fi
			}
			else
				echo "Not Active" >> $ACCESSKEY_LIST
			fi
		}
		fi 
done < "$input"

#List all Human-users and check access key for all of them.
aws iam get-group --group-name HumanUser --query 'Users[*].[UserName]' --output text >> $AWS_HUMAN_USERS
echo -e "\n========== AWS IAM -- ACCESSKEY STATUS OF HUMAN USER ==========\n" >> $ACCESSKEY_LIST
input2="$AWS_HUMAN_USERS"
while IFS= read -r var1
	do
		aws iam list-access-keys --user-name $var1 --query 'AccessKeyMetadata[*].[Status]' --output text > $ACCESSKEY_STATUS
		temp_astatus=`cat $ACCESSKEY_STATUS`
		echo -e "----------------------------------------\nACCESSKEY_STATUS	|	"$var1" \n----------------------------------------" >> $ACCESSKEY_LIST
		if [ "$temp_astatus" = "Active" ];
		then
        {
			echo -e "Active\nACTION: Access Key needs to be deleted." >> $ACCESSKEY_LIST
			echo -e "You have been recognized as having a US-East1 AWS User Account - "$var1".Access Key must not be assigned to a User Account. If you still require access for this account. \n1) Please respond back to this message immediately \n2) Login to the account as soon as possible and delete the access key for your account.\nIf you fail to change the access key within the next 7 business days, an Access Request will opened to terminate the access." | mail -s "US-East1 AWS Access Key Expired" -r cloud.infra.us@company_name.com prmalik@company_name.com
        }
		else
        {
			echo "Not Active" >> $ACCESSKEY_LIST
        }
		fi
done < "$input2"


#aws iam list-access-keys --user-name cardinals3 --query 'AccessKeyMetadata[*].[Status]' --output text
#aws iam list-access-keys --user-name cardinals3 --query 'AccessKeyMetadata[*].[CreateDate]' --output text


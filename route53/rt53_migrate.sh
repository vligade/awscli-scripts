#Route 53
############################################################################################################################
#   Name                :  RT53_migration         ::          Alias:Route53 migration                                      #
#   Purpose             :  AWS CLI script for Route53 migration.                                                           #
#   Author              :  Prateek Malik     Last modified by: Prateek    ::   ver 1.0                                     #
############################################################################################################################
#!/bin/sh
#ANAME
NOW=$(date +"%b%Y")
LOG_DIR="var/log/route53/$NOW"
ANAME_BEFORE="$LOG_DIR/ANAME_BEFORE.log"
ANAME_AFTER="$LOG_DIR/ANAME_AFTER.log"
ANAME_STATUS="$LOG_DIR/ANAME_STATUS.log"

ANAME_MGT_NAME="/root/ANAME_MGT_NAME"
#ANAME_MGT_VALUE="$LOG_DIR/MGT/ANAME_MGT_value"

ANAME_JSON="/root/change-resource-record-sets.json"
TEMP_FILE="$LOG_DIR/temp.log"
HOSTZONE_ID_FRONT=Z14SLJBMBRQPRG

# Verifying Directories
if [ ! -d $LOG_DIR ]; then
mkdir -p $LOG_DIR
echo "$LOG_DIR log directory doesn't exists , directory created"
fi

> $ANAME_BEFORE
> $ANAME_AFTER
#> $ANAME_MGT_NAME
#> $ANAME_MGT_VALUE
> $ANAME_STATUS
> $ANAME_JSON





#list record sets  -- BEFORE
aws route53 list-resource-record-sets --hosted-zone-id Z14SLJBMBRQPRG --start-record-name ohp.na.company_name.cloud. --start-record-type A --query >> $ANAME_BEFORE

cat $ANAME_MGT_NAME > $TEMP_FILE
input="$TEMP_FILE"
while IFS= read -r var
	do
		ANAME="`echo $var | awk '{print $1}'`"
		AVALUE="`echo $var | awk '{print $2}'`"
		echo -e {"\n" '"Comment"': '"DNS Route 53."',"\n" '"Changes"': ["\n"{"\n"'"Action"': '"CREATE"',"\n"'"ResourceRecordSet"': {"\n"'"Name"': '"'$ANAME'.ohp.na.company_name.cloud."',"\n"'"Type"': '"A"',"\n"'"TTL"': 60,"\n"'"ResourceRecords"': ["\n"{"\n"'"Value"': '"'$AVALUE'"'"\n"}"\n"]"\n"}"\n"}"\n"]"\n"} > $ANAME_JSON
		echo "$var" >> $ANAME_STATUS
		aws route53 change-resource-record-sets --hosted-zone-id $HOSTZONE_ID_FRONT --change-batch file://~/change-resource-record-sets.json --query "ChangeInfo[*].[Status]" --output text >> $ANAME_STATUS
	done < "$input"
	

#list record sets  -- AFTER
aws route53 list-resource-record-sets --hosted-zone-id Z14SLJBMBRQPRG --start-record-name ohp.na.company_name.cloud. --start-record-type A >> $ANAME_AFTER

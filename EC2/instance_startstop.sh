############################################################################################################################
#   Name                :  start_stop_awscli.sh         ::          Alias:System Info                                        #
#   Purpose             :  Script for starting and stopping the instance                                                   #
#   Author              :       Cloud Techops :: 			Last modified by: Prateek Malik    ::   ver 1.1                #
############################################################################################################################
NOW=$(date +"%b%Y")
LOG_DIR="/var/log/patching/$NOW"
INST_STATE="$LOG_DIR/INST_state.xml"

TEMP_DIR="/tmp/"
TEMP_FILE="$LOG_DIR/temp_aws.dat"

# Verifying Directories
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
> $INST_STATE

#i-aa30ca19 (pik-test-sp4) - instance in axway-cloud3 environment
echo "i-aa30ca19" >> $TEMP_FILE
input="$TEMP_FILE"
while IFS= read -r var
	do
		echo "<INSTID>$var"  >> $INST_STATE
		EC2_STATE=`aws ec2 describe-instance-status --instance-id i-aa30 --query 'InstanceStatuses[*].[InstanceState.Name]' --output text`
		echo "<STATE>$EC2_STATE</STATE>" >> $INST_STATE
		#sytemchecks
		aws ec2 describe-instance-status --instance-id i-aa30ca1 --query 'InstanceStatuses[*].SystemStatus[*].Details.Status]'
		#start
		aws ec2 start-instances --instance-ids $var
		#stop-instances
		aws ec2 stop-instances --instance-ids $var	
		echo "</INSTID>" >> $INST_STATE
	done < "$input"

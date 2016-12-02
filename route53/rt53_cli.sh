#Route 53
#!/bin/sh

_RT53 ()
{
echo -e "Welcome to AWS ROUTE 53 Service\n"

#list-hosted-zones and host-zone-id
echo -e "\n List of Hosted Zone :"
#aws route53 list-hosted-zones --query 'HostedZones[*].[Name,Id]' --output text
aws route53 list-hosted-zones --query 'HostedZones[*].[Name,Id]' --output table

echo "Choose from options: \n1.Create a new hosted zone\n2.Update existing hosted zone\n3.exit"
#get-hosted-zone-summary for single id
aws route53 get-hosted-zone --id Z3FHVXNJ4P762S

#create-hosted-zone
aws route53 create-hosted-zone --name test.company_name.cloud. --caller-reference DNS_Creation_CLI --hosted-zone-config Comment="Test_aws_cli"

#list-resources-of-hosted-zone
aws route53 list-resource-record-sets --hosted-zone-id Z3FHVXNJ4P762S --query 'ResourceRecordSets[*].ResourceRecords[*].[Value],[Type[*]].[Name[*]]'
aws route53 list-resource-record-sets --hosted-zone-id ZHPLPKQ0NZETB --query 'ResourceRecordSets[*].ResourceRecords[*].[Value] '

aws route53 list-resource-record-sets --hosted-zone-id Z3FHVXNJ4P762S --start-record-name syslog.mgtstaging.company_name.cloud. --start-record-type A
aws route53 list-resource-record-sets --hosted-zone-id Z3FHVXNJ4P762S --start-record-name --start-record-type A


#create a new record set
#JSON-template
In order to create a new record set, first create a JSON file to describe the new record:
echo -e "{\n"Comment": "A new record set for the zone.",\n"Changes": [\n{\n"Action": "CREATE",\n"ResourceRecordSet": {\n"Name": "api.realguess.net.",\n"Type": "CNAME",\n"TTL": 60,\n"ResourceRecords": [\n{\n"Value": "www.realguess.net"\n}\n]\n}\n}\n]\n}" >> $RT53_template
In order to create a new record set, first create a JSON file to describe the new record:
{
  "Comment": "DNS Route 53.",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "axwc-b2b1-prd .ohp.na.company_name.cloud",
        "Type": "A",
        "TTL": 60,
        "ResourceRecords": [
          {
            "Value": "10.10.16.19"
          }
        ]
      }
    }
  ]
}



aws route53 change-resource-record-sets --hosted-zone-id Z14SLJBMBRQPRG \
  --change-batch file:///path/to/record.json
  
The status of adding the new record is currently pending. Poll the server to get the updated status:
aws route53 get-change --id CHANGEID123








aws route53 get-hosted-zone --id Z14SLJBMBRQPRG






aws route53 list-resource-record-sets --hosted-zone-id Z14SLJBMBRQPRG --start-record-name ohp.na.company_name.cloud. --start-record-type A
aws route53 change-resource-record-sets --hosted-zone-idZ14SLJBMBRQPRG --change-batch file:///root/change-resource-record-sets.json


aws route53 change-resource-record-sets --hosted-zone-idZ1W9BXXXXXXXLB --change-batch file:///root/change-resource-record-sets.json



aws route53 change-resource-record-sets --hosted-zone-id Z2AXJKSVFZMTMH --change-batch file://~/root/change-resource-record-sets.json
{
  "Comment": "DNS Route 53.",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "abc.test.company_name.cloud.",
        "Type": "A",
        "TTL": 60,
        "ResourceRecords": [
          {
            "Value": "10.10.16.19"
          }
        ]
      }
    }
  ]
}




abc.test.company_name.cloud.


{
  "Comment": "Recordset for mydomainname",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "mydomainname",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "Z2FDTNDATAQYW2",
          "DNSName": "mydomainname.cloudfront.net.",
          "EvaluateTargetHealth": false
        }
      }
    }
  ]
}



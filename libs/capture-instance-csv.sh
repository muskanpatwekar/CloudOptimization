#!/bin/bash
#
#
# File variable

OUTPUT_CSV_FILE=instance-report.csv

#  Add header for csv file
echo "CLOUD_PROVIDER,INSTANCE_NAME,INSTANCE_IP,INSTANCE_STATE,DATE,TAGS" > $OUTPUT_CSV_FILE

# ---------------------------------------
# AWS: Capture aws ec2 instance state 
# ---------------------------------------

for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do

INSTANCE_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${instance_id}" --query "Tags[?Key=='Name'].Value" --output text)

INSTANCE_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${INSTANCE_NAME}" --query 'Reservations[].Instances[].PrivateIpAddress' --output text)

INSTANCE_STATE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${INSTANCE_NAME}" --query 'Reservations[].Instances[].State.Name' --output text)

DATESTAMP=$(date +%Y%m%d-%H%M%S)

echo "aws,${INSTANCE_NAME},${INSTANCE_IP},${INSTANCE_STATE},${DATESTAMP},${DATESTAMP},shutdown" >> $OUTPUT_CSV_FILE

done


#!/bin/bash
#
#
#
#

for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do

instance_state=$(aws ec2 describe-instance-status --instance-id $instance_id --query "InstanceStatuses[].InstanceState.Name" --output text)

  if [[ ${instance_state} == "running" ]]; then
    echo "INFO: Stopping instance ${instance_id}..."

    aws ec2 stop-instances --instance-ids ${instance_id} > /dev/null
  else
    echo "INFO: Instance ${instance_id} is already in stopped state."
  fi
done


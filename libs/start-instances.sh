#!/bin/bash
#
#
#
#

for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do
  
  instance_state=$(aws ec2 describe-instances --instance-id ${instance_id} --query "Reservations[].Instances[].State.Name" --output text)

  if [[ ${instance_state} == "stopped" ]]; then
    echo "INFO: Instance is in stopped state, starting instance ${instance_id}..."

     aws ec2 start-instances --instance-ids ${instance_id} > /dev/null
  else
    echo "INFO: Instance ${instance_id} is already in running state."
  fi
done


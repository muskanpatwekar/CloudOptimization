#!/bin/bash
#
#
#
#
#======================================================================================================
#=====================================FUNCTIONS=======================================================
#======================================================================================================

# Set AWS authN variable........ 
aws_auth(){
AWS_ACCESS_KEY_ID=$(yq -r '.auth_config.aws.access_key' $CREDENTIAL_FILE)
AWS_SECRET_ACCESS_KEY=$(yq -r '.auth_config.aws.secret_access_key' $CREDENTIAL_FILE)
AWS_REGION=$(yq -r '.auth_config.aws.region' $CREDENTIAL_FILE)
AWS_OUTPUT=$(yq -r '.auth_config.aws.output' $CREDENTIAL_FILE)

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_REGION
aws configure set output $AWS_OUTPUT

if aws sts get-caller-identity > /dev/null 2>&1; then
IAM_USERNAME=$(aws sts get-caller-identity --query 'Arn' --output text | awk -F"/" '{print $2}')
echo "INFO: User is successfully logged in $IAM_USERNAME"
else
echo "ERROR : Unexpected error accur while authenticating the IAM USER"
exit 1
fi 
}

# calling function aws
aws_auth


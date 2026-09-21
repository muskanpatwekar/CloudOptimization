#!/bin/bash
####################################################################################
#
# AUTHOR: Muskan patwekar
# DATE: 22-10-2024
# VERSION: 1.0.0
# DESCRIPTION: Validate if user has sudo privileges
#
####################################################################################
# CHANGELOG:
#  - Adding base directory location all files generated out of the script
#
####################################################################################
#
# Bootstrap scripts executes the initialization phase of application/program.
#
# variabls
MAIL_RECIPIENT="patwekarmuskan2@gmail.com"
MAIL_FROM="patwekarmuskan2@gmail.com"

# Function declaration

helper(){
    echo 
    echo "usage"
    echo "sudo ./$0 --action <stop|start>"
}

# Variable defination

MAIL_CONTENT="rendered-email-content.html"


# Run with sudo privilage
. libs/sudo-validate.sh

# Main program

if [[ "${#}" -eq 0 ]]; then
echo "ERROR: Missing required script parameter."
helper
exit 1
fi

if [[ ${1} == "--action" ]]; then
SCRIPT_ACTION=${2}
else
 echo "ERROR: Unrecognized parameter supplied to the script."
 helper
 exit 1
 fi



# Install dependencies
. libs/install_dependencies.sh

# Installation of clouds 
. libs/installawscli.sh
# 

# authN to cloud 
. libs/csp_aunN.sh

# start and shutdown instances

if [[ $SCRIPT_ACTION == "stop" ]]; then
. libs/shutdown-instances.sh

elif [[  $SCRIPT_ACTION == "start" ]]; then

. libs/start-instances.sh

else
echo "ERROR: Wrong value provided paramter --action: ${SCRIPT_ACTION}."
  helper
  exit 1
fi

# Capture instance state and create csv report
. libs/capture-instance-csv.sh

# Generate HTML status report for email notification
. libs/generate-html-report.sh

# Sending Email content
if [[ ! -f ${MAIL_CONTENT} ]]; then
 echo "ERROR: Email template file '${MAIL_CONTENT}' missing/not found."
  exit 1
fi

sendmail $MAIL_RECIPIENT <<EOF
From: $MAIL_FROM
To: $MAIL_RECIPIENT
Subject: HTML Format Email
Content-Type: text/html

$(cat ${MAIL_CONTENT})
EOF




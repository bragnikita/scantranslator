#!/usr/bin/env bash

BOLD=$(tput bold)
RESET=$(tput sgr0)

LOCAL_CACHE='/tmp/rexp/'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR=$(unset CDPATH && cd "${DIR}/.." && pwd)

echo "${BOLD}Updating scripts in ${DIR}/server/ ${RESET}"
rsync -azvh --progress -e 'ssh -i ~/.ssh/bragnikita-aws-keypair.pem' ${DIR}/server/ ec2-user@hajinomura.fun:/home/ec2-user/service-app

#TODO stop remote server

if [ ! -e "${APP_DIR}/Gemfile" ]; then
    echo "Wrong app directory: ${APP_DIR}"
    exit 1
fi

echo "${BOLD}Uploading contents of the application dir ${APP_DIR} ${RESET}"
mkdir -p $LOCAL_CACHE
rsync -azvh --delete-before --exclude-from ${DIR}/exclude_from_deploy.txt --progress ./ ${LOCAL_CACHE}
rsync -azvh --delete-before --progress -e 'ssh -i ~/.ssh/bragnikita-aws-keypair.pem' ${LOCAL_CACHE} ec2-user@hajinomura.fun:/home/ec2-user/service-app/current

#TODO run remote server
#TODO check remote server
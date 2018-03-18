#!/bin/bash

file_does_not_exist() {
  echo file $1 does not exists .... ignoring
}

file_is_not_newer() {
  echo file $1 is not newer .... ignoring
}

encrypt() {
  local env=$1
  local secrets_file=donstro/$env/remote.secrets
  local secrets_encr=${secrets_file}.gpg

  [ ! -e  ${secrets_file} ] && file_does_not_exist $secrets_file && return

  [ ! "${secrets_file}" -nt ${secrets_encr} ] && file_is_not_newer $secrets_file && return

  echo "encrypting ${secrets_file} to ${secrets_encr}"
  gpg --output ${secrets_encr} --symmetric ${secrets_file} --use-agent
}

for env in production test
do
  encrypt $env
done


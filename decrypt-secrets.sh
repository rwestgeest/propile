#!/bin/bash
set_modification_of() {
  local file=$1
  local refrence_file=$3
  touch -r ${refrence_file} ${file}
}
modification_time_of() {
  date -R -r $1
}

decrypt() {
  local env=$1
  local secrets_file=donstro/$env/remote.secrets
  local secrets_encr=${secrets_file}.gpg
  echo decrypting $secrets_encr to $secrets_file
  gpg --use-agent --output ${secrets_file} --decrypt ${secrets_encr}
  set_modification_of ${secrets_file} to ${secrets_encr}
}

for env in production test
do
  decrypt $env
done


#!/bin/bash
set -ex

IFS='/' read -ra file_path_split <<< "$raw_file_path"
file_name=${file_path_split[-1]}

echo "File name: ${file_name}"
echo "Run script: ${run_script}"

curl -H "Authorization: token $github_access_token" \
  -H "Accept: application/vnd.github.v3.raw" \
  -O \
  -L "$raw_file_path"

echo "Download finished!"

if [ "$run_script" = "yes" ]; then
    echo "Running script..."
    bash ./$file_name
fi

script_result=$?
exit ${script_result}
#!/bin/bash
set -ex

IFS='/' read -ra file_path_split <<< "$raw_file_path"
file_name=${file_path_split[${#file_path_split[@]} - 1]}

echo "File name: ${file_name}"
echo "Run script: ${run_script}"

curl -H "Authorization: token $github_access_token" \
  -H "Accept: application/vnd.github.v3.raw" \
  -O \
  -L "$raw_file_path"

content=$(<$file_name)
if [ "$content" = "404: Not Found" ]; then
    echo "Download failed!"
    echo "Verify the file path and GitHub Personal Access Token!"
    rm "$file_name"
    exit 1
else
    echo "Download finished!"
fi

# Make command equal to if python then python3.11 else if bash then bash else exit 1
# This is to make sure that the script is run with the correct version of python
# or bash

if [ "$command" = "python" ]; then
    command="python3.11"
elif [ "$command" = "bash" ]; then
    command="bash"
else
    echo "Error: Unknown command '$command'"
    exit 1
fi


if [ "$run_script" = "yes" ]; then
    echo "Running script '$file_name' with '$command' ..."
    $command "$file_name"
fi

script_result=$?
exit ${script_result}

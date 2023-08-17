##################################
# Author : jaison v j
# Date : 16/08/2023
# This script is to create the backup of the folder
# Version: V1
##################################
#set -x
set -e
#!/bin/bash

# checking two argument provided or not
if [ $# -ne 2 ]; then
  echo "Usage: $0 source_folder destination_folder"
  exit 1
fi
# assigning argument to variable
source_folder=$1
destination_folder=$2
# looping through all files in source folder
for file in $source_folder/*; do
# Get the file name with the full path
#echo $file
# Get the file name without the path
file_name=$(basename $file)
#echo $file_name

# Checking the file exists in the destination folder
if [ -f $destination_folder/$file_name ]; 
then
echo "File $file_name already exists in $destination_folder. Do you want to override it? (y/n) "
read answer
    if [ $answer = "y" ]; 
    then
    cp $file $destination_folder/$file_name
    echo "File $file_name copied to $destination_folder."
    elif [ $answer = "n" ]; 
    then
    echo "File $file_name skipped."
    else
    echo "Invalid input. Exiting the script."
    exit 2
    fi
else
cp $file $destination_folder/$file_name
echo "File $file_name copied to $destination_folder."
fi
done

echo "Backup completed successfully"
exit 0
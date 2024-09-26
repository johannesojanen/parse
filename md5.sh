#!/bin/bash

# check if correct number of arguments are provided
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <directory_with_files> <md5_file>"
  exit 1
fi

# assign command-line arguments to variables
file_directory="$1"
checksum_file="$2"

# check if the directory exists
if [[ ! -d "$file_directory" ]]; then
  echo "Directory not found: $file_directory"
  exit 1
fi

# check if the md5 checksum file exists
if [[ ! -f "$checksum_file" ]]; then
  echo "MD5 checksum file not found: $checksum_file"
  exit 1
fi

# read each line in the checksum file
while IFS="  " read -r expected_md5 filepath; do
  # construct the full path to the file
  full_path="$file_directory/$filepath"

  # check if file exists
  if [[ -f "$full_path" ]]; then
    # calculate the md5 of the file
    calculated_md5=$(md5sum "$full_path" | awk '{ print $1 }')

    # compare the calculated md5 with the expected md5
    if [[ "$calculated_md5" == "$expected_md5" ]]; then
      echo "PASS: $full_path"
    else
      echo "FAIL: $full_path (Expected: $expected_md5, Got: $calculated_md5)"
    fi
  else
    echo "MISSING: $full_path"
  fi
done < "$checksum_file"
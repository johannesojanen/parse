#!/bin/bash

# file containing md5 hashes and file paths
checksum_file="md5.txt"

# read each line in the checksum file
while IFS="  " read -r expected_md5 filepath; do
  # check if file exists
  if [[ -f "$filepath" ]]; then
    # calculate the md5 of the file
    calculated_md5=$(md5sum "$filepath" | awk '{ print $1 }')

    # compare the calculated md5 with the expected md5
    if [[ "$calculated_md5" == "$expected_md5" ]]; then
      echo "PASS: $filepath"
    else
      echo "FAIL: $filepath (Expected: $expected_md5, Got: $calculated_md5)"
    fi
  else
    echo "MISSING: $filepath"
  fi
done < "$checksum_file"
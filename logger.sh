#!/usr/bin/env bash

config_file=logger.config

today=`date +%Y-%m-%d.%H:%M:%S`

# Check if config file exists
if [ -f "$config_file" ]; then
    echo "$config_file exists, continuing.."

    # Read the config file into array
    mapfile -t logs < $config_file
else
    echo "File does not exist, please enter the log file paths:"

    # Store paths in array
    read -a logs

    # Loop through log path array and append to file
    for i in ${logs[@]}
    do
       echo $i >> $config_file
    done
fi

echo "Processing: ${logs[@]}"

# Create a temporary folder to store logs ready to be zipped
mkdir tmp

# Loop through logs array
for i in ${logs[@]}
do
  # Check if the log file exists
  if [ -f $i ]; then
    cp $i tmp
  fi
done

# cd to tmp, zip the entire directory and save in parent folder
tar -czvf $today.tar.gz tmp --force-local

# Remove tmp directory as no longer needed
rm -r tmp

# Prepare the S3 PUT parameters
date=`date +%Y%m%d`
logs_dir=Logs
file=$today.tar.gz
bucket=s3-bucket-name
region=eu-west-1
resource="/${bucket}/$logs_dir/${file}"
content_type="application/x-compressed-tar"
date_value=`date -R`
string_to_sign="PUT\n\n${content_type}\n${date_value}\n${resource}"
s3_key=access-key
s3_secret=secret-access-key
signature=`echo -en ${string_to_sign} | openssl sha1 -hmac ${s3_secret} -binary | base64`

# Execute PUT command to put the zipped logs into S3
curl -X PUT -T "${file}" \
  -H "Host: ${bucket}.s3.amazonaws.com" \
  -H "Date: ${date_value}" \
  -H "Content-Type: ${content_type}" \
  -H "Authorization: AWS ${s3_key}:${signature}" \
  http://${bucket}.s3.${region}.amazonaws.com/${logs_dir}/${file}

# Finally remove the logs zip from the local system
rm $today.tar.gz

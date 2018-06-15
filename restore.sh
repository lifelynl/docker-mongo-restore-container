#! /bin/bash

# Exit if a command fails
set -e

if [ "${AWS_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the AWS_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${AWS_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the AWS_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${AWS_S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the AWS_S3_BUCKET environment variable."
  exit 1
fi

if [ "${AWS_S3_PATH}" = "**None**" ]; then
  echo "You need to set the AWS_S3_PATH environment variable."
  exit 1
fi

# Create required directories
mkdir /root/backup_temp/
mkdir /root/backup_temp/original

# Copy the backup from S3
if [ "${AWS_SSE_KEY}" = "**None**" ]; then
  /usr/local/bin/aws s3 cp s3://$AWS_S3_BUCKET/$AWS_S3_PATH /root/backup_temp/backup.tar.gz
else
  /usr/local/bin/aws s3 cp --sse-c --sse-c-key="$AWS_SSE_KEY" s3://$AWS_S3_BUCKET/$AWS_S3_PATH /root/backup_temp/backup.tar.gz
fi

# Unzip + extract original backup files
tar -zxvf /root/backup_temp/backup.tar.gz

# Restore database to mongo
mongorestore --host $MONGO_HOST /root/backup_temp/original

# Remove the created backup directory
rm -rf /root/backup_temp

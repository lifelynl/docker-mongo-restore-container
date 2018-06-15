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

# Create required directory
mkdir /root/backup_temp/

# Copy the backup from S3
AWS_CMD_OPTIONS=""
if [ "${AWS_SSE_KEY}" != "**None**" ]; then
  AWS_CMD_OPTIONS+="--sse-c --sse-c-key=$AWS_SSE_KEY"
fi

/usr/local/bin/aws s3 cp $AWS_CMD_OPTIONS s3://$AWS_S3_BUCKET/$AWS_S3_PATH /root/backup_temp/backup.archive.gz

# Restore database to mongo
mongorestore --archive="/root/backup_temp/backup.archive.gz" --gzip --host $MONGO_HOST $MONGO_CMD_OPTIONS

# Remove the created backup directory
rm -rf /root/backup_temp

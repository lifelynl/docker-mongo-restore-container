# Mongo restore container
This container will download a given backup file from S3 en use mongorestore to restore the backup to the given MongoDB host (default: mongo:27017).

Note that mongorestore will only do inserts and [no updates](https://docs.mongodb.com/manual/reference/program/mongorestore/#behavior).

Inspired by [schickling/postgres-backup-s3](https://hub.docker.com/r/schickling/postgres-backup-s3/).

# Usage
Run the docker container:

    docker run \
        --env AWS_ACCESS_KEY_ID= \
        --env AWS_SECRET_ACCESS_KEY= \
        --env AWS_S3_BUCKET= \
        --env AWS_S3_PATH= \
        lifely/mongo-restore-container

The variables AWS_REGION, MONGO_HOST and AWS_SSE_KEY are optional:

    docker run \
        --env AWS_ACCESS_KEY_ID= \
        --env AWS_SECRET_ACCESS_KEY= \
        --env AWS_S3_BUCKET= \
        --env AWS_S3_PATH= \
        --env AWS_REGION=eu-west-1 \
        --env MONGO_HOST=mongo:27017 \
        --env AWS_SSE_KEY= \
        lifely/mongo-restore-container

## Docker compose
Docker compose will start a mongo container exposing port 27017 and a restore container that will run the backup script. Don't forget to set the AWS credentials.

### AWS SSE
The AWS_SSE_KEY should be a string of [exactly 32 characters](https://stackoverflow.com/a/35905265).

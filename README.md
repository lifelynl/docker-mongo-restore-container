# Mongo restore container
This container will download a given backup file from S3 en use mongorestore to restore the backup to the given MongoDB host (default: mongo:27017).

Currently using MongoDB 3.4.

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

### Testing manually
Here's a flow for making a backup and doing a restore of a MongoDB:

    # Create the Docker network
    docker network create mongo_backup_test

    # Start a database
    docker run -ti --rm \
        -p "27017:27017" \
        --network mongo_backup_test \
        --name mongo \
        mongo:3.4

    # Run the backup
    docker run -ti --rm \
        --env AWS_ACCESS_KEY_ID=YourID \
        --env AWS_SECRET_ACCESS_KEY=YourKey \
        --env AWS_S3_BUCKET=YourBucket \
        --env AWS_S3_PREFIX=YourPrefix \
        --env AWS_REGION=eu-central-1 \
        --env MONGO_HOST=mongo:27017 \
        --env AWS_SSE_KEY=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA \
        --network mongo_backup_test \
        lifely/mongo-backup-container

    # Run the Restore
    docker run -ti --rm \
        --env AWS_ACCESS_KEY_ID=YourID \
        --env AWS_SECRET_ACCESS_KEY=YourKey \
        --env AWS_S3_BUCKET=YourBucket \
        --env AWS_S3_PATH=YourPrefix/backup-2018-06-15-07-49-06.tar.gz \
        --env AWS_REGION=eu-central-1 \
        --env MONGO_HOST=mongo:27017 \
        --env AWS_SSE_KEY=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA \
        --network mongo_backup_test \
        lifely/mongo-restore-container


### AWS SSE
The AWS_SSE_KEY should be a string of [exactly 32 characters](https://stackoverflow.com/a/35905265).

#!/bin/sh

# Link service specific variables
export AWS_ACCESS_KEY=test
export AWS_SECRET_KEY=test
export AWS_REGION=us-west-2

export HOST=http://localhost:
export REGION=$AWS_REGION
export PORT=8080
export DYNAMO_PORT=8000
export ISLOCAL=true
export LINK_SERVICE_URL=$HOST$PORT

# User service specific variables
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_DATABASE_NAME=sshort
export POSTGRES_USERNAME=sshort
export POSTGRES_PASSWORD=sshort
export USER_SERVICE_PORT=8081
export USER_SERVICE_HOST=http://localhost
export USER_SERVICE_URL=$USER_SERVICE_HOST:$USER_SERVICE_PORT

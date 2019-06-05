#!/bin/sh

fail_no_var() {
	echo "ERROR: $1 variable is not set. Did you source to env.sh?"
	exit 1
}

fail_no_program() {
    echo "Error: $1 is not installed" >&2
    exit 1
}

check_env() {

	echo "Checking environment configuration..."
	if ! [ -x "$(command -v docker)" ]; then fail_no_program docker; else echo " docker: found"; fi
	if ! [ -x "$(command -v docker-compose)" ]; then fail_no_program docker-compose; else echo " docker-compose: found"; fi
	if ! [ -x "$(command -v go)" ]; then fail_no_program go; else echo " go: found"; fi
	if [ -z ${AWS_ACCESS_KEY+x} ]; then fail_no_var AWS_ACCESS_KEY; else echo " AWS_ACCESS_KEY=$AWS_ACCESS_KEY"; fi
	if [ -z ${AWS_SECRET_KEY+x} ]; then fail_no_var AWS_SECRET_KEY; else echo " AWS_SECRET_KEY=$AWS_SECRET_KEY"; fi
	if [ -z ${AWS_REGION+x} ]; then fail_no_var AWS_REGION; else echo " AWS_REGION=$AWS_REGION"; fi
	if [ -z ${HOST+x} ]; then fail_no_var HOST; else echo " HOST=$HOST"; fi
	if [ -z ${REGION+x} ]; then fail_no_var REGION; else echo " REGION=$REGION"; fi
	if [ -z ${DYNAMO_PORT+x} ]; then fail_no_var DYNAMO_PORT; else echo " DYNAMO_PORT=$DYNAMO_PORT"; fi
	if [ -z ${PORT+x} ]; then fail_no_var PORT; else echo " PORT=$PORT"; fi
	if [ -z ${ISLOCAL+x} ]; then fail_no_var ISLOCAL; else echo " ISLOCAL=$ISLOCAL"; fi
	echo ""
}


start_dbconn() {

	echo ""
	echo "####"
	echo "Starting DB connection..."
	echo "####"
	echo ""

	cd RSO_LinkService/dbConn

	IMAGE="amazon/dynamodb-local"
	docker ps -q --filter ancestor=$IMAGE | xargs -r docker stop

	docker-compose up &
	COUNT=$(docker ps | grep $IMAGE | wc -l)
	while [ $COUNT -eq 0 ]
	do
	    COUNT=$(docker ps | grep $IMAGE | wc -l)
	    echo "Waiting for container to start"
	    sleep 2
	done

	go build
	go run prepareData.go
	cd ../../
}

start_linksvc() {
	echo ""
	echo "####"
	echo "Starting LinkService..."
	echo "####"
	echo ""

	cd RSO_LinkService/service
	go build
	go run main.go
	cd ../../
}

check_env
start_dbconn
start_linksvc

echo "Finished"

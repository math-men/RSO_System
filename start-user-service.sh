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
    if ! [ -x "$(command -v mvn)" ]; then fail_no_program mvn; else echo " mvn: found"; fi
    if ! [ -x "$(command -v java)" ]; then fail_no_program java; else echo " java: found"; fi
    if ! [ -x "$(command -v python)" ]; then fail_no_program python; else echo " python: found"; fi
	if [ -z ${POSTGRES_HOST+x} ]; then fail_no_var POSTGRES_HOST; else echo " POSTGRES_HOST=$POSTGRES_HOST"; fi
	if [ -z ${POSTGRES_PORT+x} ]; then fail_no_var POSTGRES_PORT; else echo " POSTGRES_PORT=$POSTGRES_PORT"; fi
	if [ -z ${POSTGRES_DATABASE_NAME+x} ]; then fail_no_var POSTGRES_DATABASE_NAME; else echo " POSTGRES_DATABASE_NAME=$POSTGRES_DATABASE_NAME"; fi
	if [ -z ${POSTGRES_USERNAME+x} ]; then fail_no_var POSTGRES_USERNAME; else echo " POSTGRES_USERNAME=$POSTGRES_USERNAME"; fi
	if [ -z ${POSTGRES_PASSWORD+x} ]; then fail_no_var POSTGRES_PASSWORD; else echo " POSTGRES_PASSWORD=$POSTGRES_PASSWORD"; fi
	if [ -z ${LINK_SERVICE_URL+x} ]; then fail_no_var LINK_SERVICE_URL; else echo " LINK_SERVICE_URL=$LINK_SERVICE_URL"; fi
	if [ -z ${USER_SERVICE_PORT+x} ]; then fail_no_var USER_SERVICE_PORT; else echo " USER_SERVICE_PORT=$USER_SERVICE_PORT"; fi

}

start_dbconn() {

	echo ""
	echo "####"
	echo "Starting DB connection..."
	echo "####"
	echo ""

	cd RSO_user_service_kotlin/db
	docker build -t sshort_user_database .
	docker stop sshort_user_database
	docker rm sshort_user_database
	docker run -d -p $POSTGRES_PORT:$POSTGRES_PORT --name sshort_user_database sshort_user_database
	cd ../../
}

start_usersvc() {
	echo ""
	echo "####"
	echo "Starting LinkService..."
	echo "####"
	echo ""

	cd RSO_user_service_kotlin/user-service
	mvn install
	java -jar target/user-service-1.0-SNAPSHOT.jar \
		--server.port=$USER_SERVICE_PORT \
		--linksvc.url=${LINK_SERVICE_URL}
	cd ../../
}

check_env
start_dbconn
start_usersvc

echo "Finished"

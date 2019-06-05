#!/bin/sh

fail_no_var() {
    echo "ERROR: $1 variable is not set. Did you source to env.sh?" >&2
    exit 1
}

fail_no_program() {
    echo "Error: $1 is not installed" >&2
    exit 1
}

check_env() {

    echo "Checking environment configuration..."
    if ! [ -x "$(command -v npm)" ]; then fail_no_program npm; else echo " npm: found"; fi
    if [ -z ${FRONTEND_HOST+x} ]; then fail_no_var FRONTEND_HOST; else echo " FRONTEND_HOST=$FRONTEND_HOST"; fi
    if [ -z ${FRONTEND_PORT+x} ]; then fail_no_var FRONTEND_PORT; else echo " FRONTEND_PORT=$FRONTEND_PORT"; fi

}

start_frontend() {

    echo ""
    echo "####"
    echo "Starting FrontEnd..."
    echo "####"
    echo ""

    cd RSO_frontend
    HOST=$FRONTEND_HOST
    PORT=$FRONTEND_PORT
    npm start
    cd ../
}

check_env
start_frontend

echo "Finished"

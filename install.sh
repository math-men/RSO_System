#!/bin/sh

export ORGANIZATION_URL=https://github.com/math-men

install_go_pkg() {
	echo "Installing GO package $1..."
	go get $1
}

clone_if_not_exists() {
	if [ ! -d "$1" ]; then
		git clone "$ORGANIZATION_URL/$1.git"
	else
		echo "Respository $1 is arleady downloaded"
	fi
}

fail_no_program() {
    echo "Error: $1 is not installed" >&2
    exit 1
}

check_env() {

    echo "Checking environment configuration..."
	if ! [ -x "$(command -v git)" ]; then fail_no_program git; else echo " git: found"; fi
	if ! [ -x "$(command -v go)" ]; then fail_no_program go; else echo " go: found"; fi
	if ! [ -x "$(command -v docker)" ]; then fail_no_program docker; else echo " docker: found"; fi
	if ! [ -x "$(command -v docker-compose)" ]; then fail_no_program docker; else echo " docker: found"; fi
	if ! [ -x "$(command -v java)" ]; then fail_no_program java; else echo " java: found"; fi
	if ! [ -x "$(command -v mvn)" ]; then fail_no_program mvn; else echo " mvn: found"; fi
	if ! [ -x "$(command -v python)" ]; then fail_no_program python; else echo " python: found"; fi
	if ! [ -x "$(command -v pip)" ]; then fail_no_program pip; else echo " pip: found"; fi
	if ! [ -x "$(command -v npm)" ]; then fail_no_program npm; else echo " npm: found"; fi

}

download_repositories() {

	echo "####"
	echo "Downloading repositories..."
	echo "####"
	echo ""

	clone_if_not_exists RSO_LinkService
	clone_if_not_exists RSO_user_service_kotlin
	clone_if_not_exists RSO_frontend

}

install_linksvc_deps() {

	echo ""
	echo "####"
	echo "Installing LinkService dependencies..."
	echo "####"
	echo ""

	LINK_SERVICE_PATH=RSO_LinkService

	docker pull amazon/dynamodb-local
	install_go_pkg github.com/aws/aws-sdk-go/aws
	install_go_pkg github.com/aws/aws-sdk-go/aws/session
	install_go_pkg github.com/aws/aws-sdk-go/aws
	install_go_pkg github.com/aws/aws-sdk-go/service/dynamodb
	install_go_pkg github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute
	install_go_pkg github.com/go-chi/chi
	install_go_pkg github.com/go-chi/chi/middleware

}

install_usersvc_deps() {

	echo ""
	echo "####"
	echo "Installing UserService dependencies..."
	echo "####"
	echo ""

	cd RSO_user_service_kotlin/user-service
	mvn validate
	mvn dependency:copy-dependencies
	cd ..
	pip install -r features-tests/requirements.txt --user
    cd ..
}

install_frontend_deps() {

	echo ""
	echo "####"
	echo "Installing FrontEnd dependencies..."
	echo "####"
	echo ""

	cd RSO_frontend
	npm install
	cd ../

}

echo "Installing..."
check_env
download_repositories
install_linksvc_deps
install_usersvc_deps
install_frontend_deps
echo "Finished"

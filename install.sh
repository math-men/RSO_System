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

}

install_frontend_deps() {

	echo ""
	echo "####"
	echo "Installing FrontEnd dependencies..."
	echo "####"
	echo ""

	cd RSO_frontend
	npm install
	cv ../

}

echo "Installing..."
download_repositories
install_linksvc_deps
install_usersvc_deps
install_frontend_deps
echo "Finished"

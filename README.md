# RSO_System

All-in-one package to bootstrap whole app. It simplifies the process of starting application on the localhost.

## Requirements

In order to run whole application, you need to have following programs available on your system:
 - `git`
 - `go` - tested on 1.12.5
 - `docker` - tested on 18.09.2
 - `docker-compose` - tested on 1.17.1
 - `mvn` - tested on 3.6.1
 - `java` - tested on 1.8.0
 - `pip` - tested on 9.0.1
 - `python` - tested on 2.7.15
 - `npm` - tested on 6.9.0

## Usage

First, source your terminal to have correct environmental variables in it:
```sh
source env.sh
```

Then download subprojects repositories and install their dependencies:
```sh
./install.sh
```

Finally start each service in separate terminals (in each you have to source to the `env.sh` first!) :
```sh
# Term0
source env.sh
./start-link-service.sh

# Term1
source env.sh
./start-user-service.sh

# Term2
source env.sh
./start-frontend
```

Each `start-*` script performs build of particular project and then starts it using variables got from `env.sh` source file.


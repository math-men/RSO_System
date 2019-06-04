# RSO_System

All-in-one package to bootstrap whole app. It simplifies the process of starting application on the localhost.

## Usage

First, source your terminal to have correct environmental variables in it:
```sh
source env.sh
```

Next download subprojects repositories and install their dependencies:
```sh
./install.sh
```

Then start each service:
```sh
./start-link-service.sh
./start-user-service.sh
./start-frontend
```

Each `start-*` script performs build of particular project and then starts it using variables got from `env.sh` source file.


---
layout: default
nav_order: 1
title: Installing Bento on Your Local Machine 
---

# Installing Bento on Your Local Machine

## Introduction
The Bento-Local environment is designed to run directly within Docker on a user’s workstation. This allows users to create and deploy their local copy of Bento with minimal changes to their local environment and allows for a configuration that can be used with different workstation operating systems. 

The Bento-Local project supports the following build modes:
* Build:  this build mode will create production ready frontend and backend Bento Docker containers. This mode requires users to have local copies of the bento-frontend and bento-backend repositories configured as needed for the build. Note that when using build mode, there are no changes to the source code made during the build process, any changes or configurations made to the user's local copy of the source code will be reflected in the build.
* Dev:  this build mode will create Bento Docker containers suitable for local development. Note that in this mode, configuration changes will be made during the build process to use Bento-Local resources and the frontend website will reflect any changes made in the user's local copy of the source code live. The frontend container in this mode will run on port 8085 and will require using the following URL:  http://localhost:8085

All local copies of source code and configuration files used for an environment must reside within the root of the Bento-Local project folder. For example, copies of the Bento source code must be located at "bento-local/[source folder]".


Bento-local consists of three components hosted within Docker containers and a separate Dataloader container that will run the Bento dataloader scripts. Depending on configuration options the build can take several minutes. When the build is complete the Bento components will be configured as follows:

**Front End:**

* Local URL (build mode):	http://localhost/
* Local URL (dev mode):	http://localhost:8085/
* Note: The Frontend container will make requests to the backend over port 8080. This container is built using a local git checkout of the bento-frontend repository.

**Back End:**  

* Local URL:	http://localhost:8080/
* Note: The Backend container will make requests to Neo4j over port 7474 and pass requested data to the Frontend. This container is built using a local git checkout of the bento-backend repository.

**File Downloader**

* Local URL:	http://localhost:8081/
* Note: The Bento-Local File Downloader will simulate the functionality used by Bento for downloading data files. This function is run in a simulation mode and will not include the full implementation of this feature.

**Neo4j:**

* Local URL:	http://localhost:7474/
* Note: The Neo4j container holds the graph database for the Bento system and will return data to the Backend when requested.

**Elasticsearch:**

* Local URL:	http://localhost:9200/
* Note: The Elasticsearch container holds the Elasticsearch database for the Bento system. When running in "build" mode it will be required to run the Elasticsearch dataloader in order to populate the database ("dev" mode does this automatically).

**Bento Dataloader:**

The Bento Dataloader performs two functions:
 
* Dataloader: The Dataloader will load a local dataset into the graph database hosted within the Neo4j container. This component requires local copies of the bento-backend and bento-model repositories as well as a local copy of the data to be loaded. In order to load data using this feature the Bento-Local Neo4j container must be running.
* Dataloader-es: The Elasticsearch Dataloader will load required data from the Bento-Local Neo4j database into the Bento-Local Elasticsearch database. In order to load data using this feature, the Bento-Local Neo4j container and the Bento-Local Elasticsearch container must both be running.

## Configuring the Runtime Environment

Here are instructions for configuring specific environments:

### Amazon Linux

The AWS WorkSpaces provisioned for Bento developers need additional configuration to successfully build the containers provided by `bento-local`.

1. Edit the system's `/etc/resolv.conf` file by commenting out the existing name servers. For example:

    ```text
    #nameserver 172.16.0.58
    #nameserver 172.16.1.121
    #nameserver 198.19.0.2
    ```

2. Edit the system's `/etc/resolv.conf` file by adding the following line:

    ```text
    nameserver 8.8.8.8
    ```

## Installing Docker
To install Docker choose from the following options:

**Install Docker Desktop:**

Docker Desktop is an application for MacOS and Windows machines for the building and sharing of containerized applications and microservices. It can be downloaded from: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

Once Docker Desktop has been installed docker commands can be run from Powershell or terminal windows.

**Install Docker Engine:**

Instructions for installing Docker Engine can be found at: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

If choosing this option docker-compose will need to be installed separately. Instructions for installing docker-compose can be found at: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)


## Installing Bento

After installing Docker perform the following tasks from the command line to finish setting up Bento:

### Get the Bento-local scripts

The bento-local scripts can be found in Github at: [https://github.com/CBIIT/bento-local](https://github.com/CBIIT/bento-local) NOTE: these scripts are available on the master branch

You can pull these onto your local workstation using any git client you have installed.

### Initialize your bento-local project

Bento-Local includes initialization scripts that will prepare your local checkout for building. These scripts will checkout all of the required Bento source code and include demo data to use if desired. After running the initialization scripts your Bento-Local project will be ready to be built.

Details for the initialization script can be found in the README file in bento-local/initialization. Note that for modes other than "dev_mode", building bento-local will require updates to configuration files. Initializing your bento-local project will create the following additional folders:

* bento-frontend: cloned from https://github.com/CBIIT/bento-frontend.git
* bento-backend: cloned from https://github.com/CBIIT/bento-RI-backend.git
* bento-files: cloned from https://github.com/CBIIT/bento-files.git
* bento-model: cloned from https://github.com/CBIIT/bento-model.git
* data: a copy of the included demo data

Note that the bento-local build will use the actual code you have cloned locally when it builds - if you require features from a specific branch you must clone that branch specifically using git or by updating the defaults used in the initializion script. For a vanilla install of Bento the default branches will be sufficient.

### Configure Environment settings for your local instance

The bento-local build and initialization scripts use configuration options defined in the `.env` file that is included within the bento-local project. This file contains default values to use when building Bento-Local, it is possible to use the default settings to build Bento-Local in "dev" mode. The configurations can be changed as needed, however please note that the username for new Neo4j containers should always remain "neo4j". The default values for this file are:

```
########################################
#                                      #
#      INITIALIZATION PROPERTIES       #
#                                      #
########################################

USE_DEMO_DATA=yes
# Set to "yes" to seed the project with the provided demo data set

BACKEND_REPO=https://github.com/CBIIT/bento-RI-backend.git
BACKEND_BRANCH=master

FRONTEND_REPO=https://github.com/CBIIT/bento-frontend.git
FRONTEND_BRANCH=master

MODEL_REPO=https://github.com/CBIIT/BENTO-TAILORx-model.git
MODEL_BRANCH=master

FILES_BRANCH=main

########################################
#                                      #
#          RUNTIME PROPERTIES          #
#                                      #
########################################

COMPOSE_HTTP_TIMEOUT=200
# set docker timeout

DATE=01/01/2023
# Defines the current date (used for files container)

BUILD_MODE=dev
# Defines the build type used when building the project. Available options are:  demo, build, dev

FRONTEND_SOURCE_FOLDER=bento-frontend
# Set to your local copy of the frontend code - the default value for this is "bento-frontend". NOTE: this folder MUST be located within the folder specific to the project you are building

BACKEND_SOURCE_FOLDER=bento-backend
# Set to your local copy of the backend code - the default value for this is "bento-backend". NOTE: this folder MUST be located within the folder specific to the project you are building

BENTO_DATA_MODEL=bento-model
# Set to your local copy of the Bento data model - the default value for this is "bento-model". NOTE: this folder MUST be located within the folder specific to the project you are building

FILES_HOST=localhost
# The hostname to use when connecting to the files microservice - the default value for this is set to use localhost

BACKEND_HOST=localhost
# The hostname to use when connecting to the backend microservice - the default value for this is set to use localhost

ES_HOST=bento-es
# The hostname to use when connecting to elasticsearch - the default value for this is set to use the local elasticsearch container created by bento-local

NEO4J_HOST=neo4j
# The hostname to use when connecting to neo4j with the bento-local dataloader - the default value for this is set to use the local neo4j container created by bento-local

NEO4J_USER=neo4j
# The user name to set for Neo4j - this should remain as the default value of "neo4j" for local neo4j containers

NEO4J_PASS=neo4j_pass
# The password to set for Neo4j. This can be changed if desired
```

Note that the locations of the FRONTEND_SOURCE_FOLDER and BACKEND_SOURCE_FOLDER are important. These values are relative paths and must be within the root of the Bento-Local project.

### Run the Bento-local Environment

***docker-compose environment variables:***

The docker-compose files for bento-local have been written to make use of Buildkit and the Docker CLI. The commands used for docker-compose should set these options as active by passing environment variables as:

* Windows: ```$Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1;```

* Linux/Mac: ```COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1```

Many of the commands listed in this document will need to be appended to this variable declaration. Choose the correct command for the system you are running on.

### Running Bento-local services
NOTE: all commands must be run from within the root of the Bento-Local project.

To build the bento-local infrastructure and start all containers:

	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose up -d
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up -d

To rebuild an individual container (NOTE: The available containers for this command are: bento-backend, bento-frontend, bento-files, bento-es, neo4j):

	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose up -d --no-deps --build <service_name>
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up -d --no-deps --build <service_name>
	
To stop all running bento-local containers:

	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose down
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose down

To stop a single running container:

	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose down <service_name>
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose down <service_name>
	
To attach a shell to a running container (this can be useful when verifying configurations or troubleshooting):

	docker exec -it <container name> /bin/sh

### Changing the Bento-local build mode

To change the build mode of your Bento-Local project the following steps must be taken:

* Update the BUILD_MODE variable in the .env file: this should be changed to the desired mode

* Rebuild your bento containers - to rebuild your containers use the following command:

```
	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose up -d --build
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up -d --build
```

Taking these steps will rebuild the Bento-Local environment with the desired build mode. Note that rebuilding Bento-Local does not require reloading data.

### Cleaning your Bento-local project

The following commands can be used to remove the Docker cache and to return your system to a clean state. When running these commands only unused objects will be removed - if you want to fully remove all cached objects you will need to stop all running Docker containers by running "docker-compose down"

To clean docker objects for all stopped containers (this command can be used to return to a clean system and start over with new configurations):

	docker system prune -a

To clean all docker volumes (NOTE: this will remove any data loaded into Neo4j):

	docker system prune --volumes


### Commands for running the Bento-local dataloader:

Note that the dataloader requires the following local resources:

* A local copy of the bento-frontend source code. This will be used to supply schema files. The location of this folder must be within the root folder of the version of bento-local you are using and its location is set by the FRONTEND_SOURCE_FOLDER variable in the .env file. This can be obtained by running the initialization script.
* A local copy of the bento-model source code. This will be used to supply data model files. The location of this folder must be within the root folder of the version of bento-local you are using and its location is set by the BENTO_DATA_MODEL variable in the .env file. The Bento data model can be found at:  https://github.com/CBIIT/bento-model.git.  This can be obtained by running the initialization script.
* A local copy of the data you intend to load. This data must be configured to match the Bento data model and schema and located in a folder named "data" within the bento-local project (ex. "bento-local/dev_mode/data").  A set of demo data can be obtained by running the initialization script.
* A properly configured copy of the dataloader configuration file located at dataloader/bento-local.yml. This file does not require any changes from the version in Github and will use the neo4j credentials and folder locations defined in the .env file.

To start the Dataloader container and load data to Neo4j:

	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose -f dataloader.yml up --build bento-dataloader
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f dataloader.yml up --build bento-dataloader

* NOTE: In order to load data using this feature the Bento-Local neo4j container must be running.

To start the Dataloader container and load data from Neo4j to Elasticsearch:

	* Windows:    $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose -f dataloader-es.yml up --build bento-dataloader-es
	* Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f dataloader-es.yml up --build bento-dataloader-es

* NOTE: In order to load data using this feature both the Bento-Local neo4j container and the bento-es container must be running.

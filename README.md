The bento-local files can be used to create a local bento environment using docker-compose. This will create all required services and prepare the db to have data loaded.
There is also a dataloader component that can be used to load a locally stored dataset into the local Neo4j instance used by bento-local.

Use the environment variables in the .env file to define parameters for the bento-local environment.

This project uses docker and docker-compose and can be run on Windows, Mac, or Linux.

To install docker and docker-compose on Windows or Mac use Docker Desktop:

	https://www.docker.com/products/docker-desktop

To install docker (Linux):

	curl -fsSL https://get.docker.com/ | sh

To install docker-compose (Linux):

	curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose


Commands for running bento-local services:
	NOTE: the docker-compose files for bento-local have been written to make use of Buildkit and the Docker CLI. The commands used should set these options as active by passing environment variables as:
	
		Windows (powershell):  $Env:COMPOSE_DOCKER_CLI_BUILD=1; $Env:DOCKER_BUILDKIT=1; docker-compose <command>
		Linux/Mac:  COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose <command>
	
	For the purposes of this document the Linux/Mac version of this command will be used.


To build and load bento infrastructure (from the root of the bento-local project):

	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up -d

To rebuild an individual container:

	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up -d --no-deps --build <service_name>
	
		NOTE: The available containers for this command are: bento-backend, bento-frontend, neo4j

To build and run the dataloader container:

	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f dataloader.yml up --build bento-dataloader

To stop a container:

	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose down <service_name>

To stop all bento-local containers:

	COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose down

To clean docker objects for all stopped containers (this command can be used to return to a clean system and start over with new configurations):

	docker system prune -a

TO clean all docker volumes (NOTE: this will remove any data loaded into Neo4j):

	docker system prune --volumes

To attach a shell to a running container:

	docker exec -it <container name> /bin/bash   (use /bin/ash for frontend and backend containers as they are based on alpine)


Notes on script behavior:

	- The script requires defining a .env file:

	FRONTEND_SOURCE_FOLDER=<value>  set to your local copy of the frontend code - NOTE: this MUST be located within the bento-local folder
	BACKEND_SOURCE_FOLDER=<value>  set to your local copy of the backend code - NOTE: this MUST be located within the bento-local folder
	NEO4J_USER=<value>  the user name to set for Neo4j
	NEO4J_PASS=<value>  the password to set for Neo4j

	- For the Bento Frontend there is a "dev" mode that will show any changes made to the bento-frontend source files as live updates on its website. To build the dev
	  container rename 'bento-local/docker-compose.yml.dev' to 'bento-local/docker-compose.yml' and 'bento-local/frontend/Dockerfile.dev' to 'bento-local/frontend/Dockerfile'.
	  Note that you will need to rename or remove existing files to do this.
The bento-local files can be used to create a local bento environment using docker-compose. This will create all required services and prepare the db to have data loaded. There is also a dataloader component that can be used to load a locally stored dataset into the local Neo4j instance used by bento-local.

The scripts for this project are separated into three different modes:

	1. build mode:  this will create production ready Docker containers for the frontend and backend bento projects
	2. dev mode:  this will create Docker containers for the frontend and backend bento projects suitable for local development
	3. demo mode: this will load pre-configured bento containers

To run a local bento environment launch it from within the folder for your desired mode.
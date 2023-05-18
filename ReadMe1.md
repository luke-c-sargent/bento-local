# Overview

The Bento-Local environment is designed to run directly within Docker on a user’s workstation. This allows users to create and deploy their local copy of Bento with minimal changes to their local environment and allows for a configuration that can be used with different workstation operating systems.

## Requirements
- Docker
- Git
- Admin or Sudo Access on the system on which bento-local is getting installed 

## Optional 
- Docker Desktop 

## Getting Started
To get started with Bento-Local, follow these steps:
1. Clone or Download Bento-local Scripts. 
2. Initalize Project. Which will clone specific versions and branches form github. 
3. Build & Run Docker containers 


### 1. Cloning Bento-Local on the system. 
Clone the "Bento-Local" repository to your local system using Git. The following command clones the master branch, which always contains the latest released version of Bento:
```
git clone https://github.com/CBIIT/bento-local.git
```

If you need an unreleased or older version of Bento, specify the branch or version number:
```
# Example for an unreleased version
git clone -b 4.0.0 https://github.com/CBIIT/bento-local.git

# Example for an older version
git clone -b 3.9.0 https://github.com/CBIIT/bento-local.git
```

Change to the "bento-local" directory:
```
cd bento-local/
```

### 2. Initalize Project
> **Warning**: The initialization scripts are location-specific and should only be run inside the corresponding directory:  ``initialization/mac_linux`` for Mac/Linux or ``initialization/windows/`` for Windows. Running the scripts from any other location may not work.

To initialize Bento-Local, follow these steps:
 1.  Change to the appropriate directory for your host operating system:
     - Mac/Linux: ```cd initialization/mac_linux/```
     - Windows: ```cd initialization/windows/```
 2. Execute the initialization script:
    - Mac/Linux: ```sh ./init.sh```
    - Windows: ```init.bat```
 3. During script execution, you will be prompted with a few questions. If you're unsure, default values are provided as well:
      :grey_question: use demo data [default=yes]: (options are ``` yes | no ```)
    - set bento-backend repository [default=https://github.com/CBIIT/bento-RI-backend.git]: 
    - set bento-backend branch [default=4.10.0]:
    - set bento-frontend repository [default=https://github.com/CBIIT/bento-frontend.git]:
    - set bento-frontend branch [default=4.0.0]:
    - set bento-model repository [default=https://github.com/CBIIT/BENTO-TAILORx-model.git]:
    - set bento-model branch [default=master]:
    > **Note**: Pressing the "return" key without providing any input will use the default value. 
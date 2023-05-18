# Overview

The Bento-Local environment is designed to run directly within Docker on a user’s workstation. This allows users to create and deploy their local copy of Bento with minimal changes to their local environment and allows for a configuration that can be used with different workstation operating systems.

## Requirements
- Docker
- Git
- Admin or Sudo Access on the system on which bento-local is getting installed 

## Optional 
- Docker Desktop 

## Getting Started
To Get started on Bento local here are few steps that needs to be performed. 
1. Clone or Download Bento-local Scripts. 
2. Initalize Project. Which will clone specific versions and branches form github. 
3. Build & Run Docker containers 


### 1. Cloning Bento-Local on the system. 
 - Clone "Bento-local" repositry using git on local system. When cloned using below command, git will clone master branch which always have most latest released version of bento. 
```
git clone https://github.com/CBIIT/bento-local.git
```
- Here is command to get Un-Released version or Older version of bento, 
```
// i.e git clone -b 4.0.0 https://github.com/CBIIT/bento-local.git
//  OR git clone -b 3.9.0 https://github.com/CBIIT/bento-local.git
git clone -b <Bento_Version> https://github.com/CBIIT/bento-local.git
cd bento-local/
```

### 2.Initalize Project
> **Warning**
> Initialization scripts are localtion specific, these script should be ran inside ``initialization/mac_linux`` or ``initialization/windows/`` directory only. Running scripts any location may not work. 
To Initalize bento-local here are steps to follow, 
 1.  Change Directory to Either of one location depending on Host Opreation system 
     - Mac/Linux: ```cd initialization/mac_linux/```
     - Windows: ```cd initialization/windows/```
 2. Exacute initialization script,
    - Mac/Linux: ```sh ./init.sh```
    - Windows: ```init.bat```



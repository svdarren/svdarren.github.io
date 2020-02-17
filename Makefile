# Docker image used for container
IMAGE=gitpod/workspace-full

# Variables for container name and paths
PROJECT_NAME=$(lastword $(subst /, ,$(PWD)))
LOCAL_PATH=${PWD}
#TEMP_CONTAINER_NAME="${PROJECT_NAME}_$(shell date +'%H%M%S')"
CONTAINER_NAME=${PROJECT_NAME}
CONTAINER_PATH=/workspace/${PROJECT_NAME}

# Common parameters for starting the container
SHARED_START_PARAMS= \
	--interactive \
	--tty \
	--volume=${LOCAL_PATH}:${CONTAINER_PATH}:delegated \
	--workdir ${CONTAINER_PATH} \
	--publish 80:80 \
	--publish 4000:4000 \
	--publish 8002:8002

# Detect a package manager for pre-install
ifneq ($(wildcard ./Pipfile),)
INSTALL_CMD=pipenv install
else
ifneq ($(wildcard ./Gemfile),)
INSTALL_CMD=bundle install
else
ifneq ($(wildcard ./Package.json),)
INSTALL_CMD=npm install
else
INSTALL_CMD=echo 'No known package file to install'
endif
endif
endif


.PHONY: start create install run clean

ifeq ($(shell docker container inspect --format='{{.Config.Image}}' ${PROJECT_NAME}),)
start: create install
else
start:
endif
	####################################
	### STARTING EXISTING CONTAINER ###
	####################################
	docker start \
		--attach \
		--interactive \
		${PROJECT_NAME}

create:
	####################################
	### CREATING NEW NAMED CONTAINER ###
	####################################
	docker create \
		--name=${PROJECT_NAME} \
		${SHARED_START_PARAMS} \
		${IMAGE}

install:
	####################################
	####### INSTALL DEPENDANCIES #######
	####################################
	docker start ${PROJECT_NAME}
	####################################
	docker exec \
		--tty \
		${PROJECT_NAME} \
		bash --login -c "${INSTALL_CMD}"
	####################################
	docker stop ${PROJECT_NAME}

run:
	####################################
	# RUNNING TEMPORARY NEW CONTAINER ##
	####################################
	docker run \
		--rm \
		${SHARED_START_PARAMS} \
		${IMAGE}

clean:
	####################################
	### REMOVING EXISTING CONTAINER ####
	####################################
	docker rm \
		${PROJECT_NAME}

IMAGE=gitpod/workspace-full

PROJECT_NAME=$(lastword $(subst /, ,$(PWD)))
LOCAL_PATH=${PWD}
#TEMP_CONTAINER_NAME="${PROJECT_NAME}_$(shell date +'%H%M%S')"
CONTAINER_NAME=${PROJECT_NAME}
CONTAINER_PATH=/workspace/${PROJECT_NAME}

SHARED_START_PARAMS= \
	--interactive \
	--tty \
	--volume=${LOCAL_PATH}:${CONTAINER_PATH}:delegated \
	--workdir ${CONTAINER_PATH} \
	--publish 80:80 \
	--publish 4000:4000 \
	--publish 8002:8002


.PHONY: start
start: create
	### STARTING EXISTING CONTAINER ###
	docker start --attach --interactive ${PROJECT_NAME}

.PHONY: create
create:
ifeq ($(shell docker container inspect --format='{{.Config.Image}}' ${PROJECT_NAME}),)
	### CREATING NEW NAMED CONTAINER ###
	docker create \
		--name=${PROJECT_NAME} \
		${SHARED_START_PARAMS} \
		${IMAGE}
endif

.PHONY: run
run:
	### RUNNING TEMPORARY NEW CONTAINER ###
	docker run \
		--rm \
		${SHARED_START_PARAMS} \
		${IMAGE}

.PHONY: clean
clean:
	### REMOVING EXISTING CONTAINER ###
	docker rm \
		${PROJECT_NAME}

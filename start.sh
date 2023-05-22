#!/bin/bash

# ================
# Script structure
# ================

# Show usage via commandline arguments
usage() {
		echo "~~~~~~~~~~~"
		echo " U S A G E"
		echo "~~~~~~~~~~~"
		echo "Usage: ./init-ci.sh ENV_TYPE"
		echo "Required:"
		echo "    - ENV_TYPE: set environment to qa or prod"
		echo ""
		exit
}

unset_vars() {
	echo "$1 unindentified"
	# unset variables 
	unset $(grep -v '^#' $1 | sed -E 's/(.*)=.*/\1/' | xargs)
	exit 0

}

# login() {
#   #docker login
#   gcloud auth login
#   gcloud auth configure-docker $GCLOUD_REGISTRY_URL
#   gcloud config set project $PROJECT_ID
# }

# ===================
# Main
# ===================

export ROOT_PATH="$(pwd)"

# Process command line arguments
# If no arguments provided, display usage information
[[ $# -eq 0 ]] && usage

if [[ $# -eq 1 ]]; then
    export ENV_TYPE=$1
		export CONFIG_PATH="$ROOT_PATH/config"
    export ENV_FILE="$ROOT_PATH/.$ENV_TYPE.env"

	if  [[ -f $ENV_FILE ]]; then
		echo "Execution with repository environmental variables:"
		echo "    - ENV_TYPE: $ENV_TYPE"
    source "$ROOT_PATH/setenv.sh" $ENV_TYPE
	  
		#docker login
		#docker-compose -f ${DOCKERCOMPOSE_FILE} build middleware-env
		docker-compose -f ${DOCKERCOMPOSE_FILE} build middleware-dev --no-cache
		docker-compose -f ${DOCKERCOMPOSE_FILE} build middleware --no-cache
		docker-compose -f ${DOCKERCOMPOSE_FILE} up middleware
		#docker-compose down
		#docker tag "${DOCKER_REGISTRY_URL}/${SERVICE_IMAGE_NAME}:${ENV_TYPE}" "${GCP_REGISTRY_URL}/${GCP_PROJECT_ID}/ultravision/${GCP_REPO_NAME}:${ENV_TYPE}"
		#docker push "${GCP_REGISTRY_URL}/${GCP_PROJECT_ID}/ultravision/${GCP_REPO_NAME}:${ENV_TYPE}"
		

  else
    unset_vars $ENV_FILE
		usage
		exit 0
  fi
fi

exit 1

# docker compose down -v
# docker compose up wp
# docker-compose --env-file .\.envs\.env config


# if [[ $# -eq 1 ]]; then
#     export ENV_TYPE=$1
# 		export CONFIG_PATH="$ROOT_PATH/config"
#     export ENV_FILE="$ROOT_PATH/.$ENV_TYPE.env"

# 	if  [[ -f $ENV_FILE ]]; then
# 		echo "Execution with repository environmental variables:"
# 		echo "    - ENV_TYPE: $ENV_TYPE"
#     source "$ROOT_PATH/setenv.sh" $ENV_TYPE

#     if [ $( docker images | grep $ENV_BASE_TAG | awk '{print $1":"$2}' | uniq | wc -l ) = 0 ]; then
#       docker build --target env --tag $ENV_BASE_IMAGE:$ENV_BASE_TAG -f "$CONFIG_PATH/build.Dockerfile" . --no-cache
#       #docker tag  $ENV_BASE_IMAGE:$ENV_BASE_TAG ticblue/$ENV_BASE_IMAGE:$ENV_BASE_TAG
#       #docker push ticblue/$ENV_BASE_IMAGE:$ENV_BASE_TAG
#       echo "Development environment:"
#       echo "    - $ENV_BASE_IMAGE:$ENV_BASE_TAG created."
#     else
#       echo "Development environment:"
#       echo "    - $ENV_BASE_IMAGE:$ENV_BASE_TAG already created."
#     fi
		
#     if [ $( docker images | grep $DOCKER_IMAGE | awk '{print $1":"$2}' | grep $ENV_TYPE | uniq | wc -l ) -gt 0 ]; then
#       echo "Docker image:"
#       echo "    - $ENV_TYPE : $DOCKER_IMAGE:$ENV_TYPE already created."
#     else
#       echo "Docker image:"
#       echo "    - $ENV_TYPE : $DOCKER_IMAGE:$ENV_TYPE does not exists."
#       case $1 in
#         qa)
#           docker build --target dev --tag $DOCKER_IMAGE:dev -f "$CONFIG_PATH/build.Dockerfile" . --no-cache
#           docker build --target $ENV_TYPE --tag $DOCKER_IMAGE:$ENV_TYPE -f "$CONFIG_PATH/testing.Dockerfile" .
#         ;;
#         prod)
#           docker build --target staging --tag $DOCKER_IMAGE:staging -f "$CONFIG_PATH/build.Dockerfile" . --no-cache
#           docker build --target $ENV_TYPE --tag $DOCKER_IMAGE:$ENV_TYPE -f "$CONFIG_PATH/prod.Dockerfile" .        
#         ;;
#         *)
#           unset_vars $ENV_FILE
#           exit 0
#         ;;
#       esac
#       echo "Docker image $DOCKER_IMAGE:$ENV_TYPE created" 
#     fi
#     #login
#     docker tag $DOCKER_IMAGE:$ENV_TYPE $GCLOUD_DOCKER/$PROJECT_ID/$GCLOUD_DOCKER_REPO:$ENV_TYPE
#     #docker push $DOCKER_IMAGE:$ENV_TYPE
#     #docker push $GCLOUD_DOCKER/$PROJECT_ID/$GCLOUD_DOCKER_REPO:$ENV_TYPE
#   else
#     unset_vars $ENV_FILE
# 		usage
# 		exit 0
#   fi
# fi

# exit 1

# # mysql -h 127.0.0.1 -P 3306 --protocol=TCP -u root -p
# # docker compose build --no-cache wp
# # docker compose down -v
# # docker compose up wp
# # docker-compose --env-file .\.envs\.env config
# .bash_aliases

alias ll='ls -l --human-readable --color=auto'
alias la='ls -l --human-readable --color=auto --almost-all'
alias dirs='command dirs -v'

# SAS-specific bits for obtaining AWS credentials and running various
# CI360-specific utilities
#
alias awskey='getawskey -duration 43200'
alias awsecr='aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 952478859445.dkr.ecr.us-east-1.amazonaws.com'
alias bt='docker run --rm -e SPRINT=${SPRINT} -v ${PWD}:/project 952478859445.dkr.ecr.us-east-1.amazonaws.com/mkt-docker/builder-jdk:v${SPRINT}'
alias btb='docker run --rm -it -v ${BUILD_TOOL_HOME}:/root/.gradle -v ~/.aws:/root/.aws -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/project 952478859445.dkr.ecr.us-east-1.amazonaws.com/mkt-docker/builder-jdk:v${SPRINT} /bin/bash'

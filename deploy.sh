#!/bin/bash
set -e

#
# Private deploy script, in order to:
# - push local commits to GitHub
# - build and push a new Docker image to Docker Hub
# - Access the server via SSH and run the update script there
#


PROJECT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$PROJECT_DIR"
git push
docker build -t simonesestito/foody:latest "$PROJECT_DIR"
docker push simonesestito/foody:latest
ssh foody ./projects-manager update foody

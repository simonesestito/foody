#!/bin/bash
set -e

PROJECT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
docker build -t simonesestito/foody:latest "$PROJECT_DIR"
docker push simonesestito/foody:latest
ssh foody ./projects-manager update foody

#!/bin/bash
set -e

PROJECT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$PROJECT_DIR"
git push
docker build -t simonesestito/foody:latest "$PROJECT_DIR"
docker push simonesestito/foody:latest
ssh foody ./projects-manager update foody
# FIXME: Fix env vars processing
ssh foody mv foody/.env.bak foody/.env
ssh foody docker compose --project-directory foody down
ssh foody docker compose --project-directory foody up -d

#!/usr/bin/env bash

docker-compose --env-file .env down -v; docker-compose --env-file .env up --build

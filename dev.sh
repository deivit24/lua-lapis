#!/usr/bin/env bash

docker-compose --env-file .env.dev down -v; docker-compose --env-file .env.dev up --build

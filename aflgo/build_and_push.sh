#!/bin/bash

docker build -t patoresearch/aflgo-prereq -f prereq.Dockerfile .
docker push patoresearch/aflgo-prereq:latest

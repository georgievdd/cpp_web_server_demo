#!/bin/bash

docker build -t crow-server .

docker run -d \
  --name crow-server \
  -p 8086:8086 \
  -v $(pwd)/public:/app/public \
  crow-server
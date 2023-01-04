#!/bin/sh

npm install --prefix /stats

pm2 start /stats/index.js

start-kafka.sh
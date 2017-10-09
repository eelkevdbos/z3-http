#!/usr/bin/env /bin/sh

docker build . -t evdb/z3-http:${TAG:-latest}

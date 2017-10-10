#!/usr/bin/env /bin/sh

docker pull golang:1.9-alpine

# build the binary inside a golang image
docker run --rm \
	-v $(pwd):/usr/src/z3-http -w /usr/src/z3-http \
	golang:1.9-alpine /bin/sh -c "CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ."

echo "Binary was built successfully"

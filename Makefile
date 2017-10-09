.PHONY: build push

build:
	docker build . -t evdb/z3-http

push:
	docker push evdb/z3-http

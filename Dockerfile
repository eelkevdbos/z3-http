FROM golang:1.9-alpine

MAINTAINER Eelke van den Bos <eelkevdbos@gmail.com>

ARG Z3_VERSION=4.5.0

WORKDIR /go/src/z3-http

COPY . .


RUN apk add --no-cache g++ \
    && apk add --no-cache --virtual build-deps python wget make \
    && wget https://github.com/Z3Prover/z3/archive/z3-${Z3_VERSION}.tar.gz \
    && tar -xvzf z3-${Z3_VERSION}.tar.gz \
    && cd z3-z3-${Z3_VERSION} \
    && python scripts/mk_make.py \
    && cd build && make && make install \
    && apk del build-deps \
    && cd /go/src/z3-http \
    && go-wrapper download && go-wrapper install

EXPOSE 80

CMD ["go-wrapper", "run"]

FROM python:3.6-alpine

MAINTAINER Eelke van den Bos <eelkevdbos@gmail.com>

ARG Z3_VERSION="4.5.0"
ENV Z3_ARGS="-smt2,-in"

RUN apk add --no-cache g++ \
    && apk add --no-cache --virtual build-deps build-base ca-certificates python wget make \
    && wget https://github.com/Z3Prover/z3/archive/z3-${Z3_VERSION}.tar.gz \
    && tar -xvzf z3-${Z3_VERSION}.tar.gz \
    && cd z3-z3-${Z3_VERSION} && python scripts/mk_make.py \
    && cd build && make && make install && cd ../.. \
    && rm -rf z3-z3-${Z3_VERSION} \
    && rm -rf z3-${Z3_VERSION}.tar.gz \
    && apk del build-deps

COPY server.py server.py

EXPOSE 80

CMD ["python", "server.py"]

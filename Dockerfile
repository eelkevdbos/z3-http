FROM golang:1.9-stretch

MAINTAINER Eelke van den Bos <eelkevdbos@gmail.com>

WORKDIR /go/src/z3-http

COPY . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends z3 \
    && rm -rf /var/lib/apt/lists/* \
    && go-wrapper download && go-wrapper install

EXPOSE 80

CMD ["go-wrapper", "run"]
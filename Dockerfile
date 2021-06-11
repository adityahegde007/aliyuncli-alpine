#Build aliyun-cli binary ourselves because of issue
#in alpine https://github.com/aliyun/aliyun-cli/issues/54

FROM golang:alpine3.13 as cli_builder
RUN apk update && apk add curl git make
RUN mkdir /srv/aliyun
WORKDIR /srv/aliyun
RUN git clone https://github.com/aliyun/aliyun-cli.git
RUN git clone https://github.com/aliyun/aliyun-openapi-meta.git
ENV GOPROXY=https://goproxy.cn

WORKDIR aliyun-cli
RUN make deps; \
    make testdeps; \
    make build;

FROM docker:19

#Install python 3 & jq
RUN apk update && apk add python3 py3-pip python3-dev jq

# Install Aliyun CLI from builder
COPY --from=cli_builder /srv/aliyun/aliyun-cli/out/aliyun /usr/bin

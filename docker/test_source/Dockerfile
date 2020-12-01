FROM docker-mirror.sh.synyi.com/debian:buster

ADD .ci_env .
#默认的/bin/sh是dash
SHELL ["/bin/bash", "-c"]

RUN env

RUN source .ci_env && env #只有同一层里才有source的变量

RUN env #不同的层里并没有source的变量

CMD sleep 10000
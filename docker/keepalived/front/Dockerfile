FROM ubuntu:18.04
RUN sed -i "s@\(.*http://\)[^/]*\(.*\)@\1mirror.sy\2@" /etc/apt/sources.list && \
    apt update && \
    apt install -y net-tools iputils-ping nginx curl vim keepalived rsyslog
WORKDIR /app
COPY . .
RUN chmod -x * && \
    cp default /etc/nginx/sites-available/default
CMD service rsyslog start && \
    service nginx start && \
    bash
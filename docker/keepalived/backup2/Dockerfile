FROM ubuntu:18.04
RUN sed -i "s@\(.*http://\)[^/]*\(.*\)@\1mirror.sy\2@" /etc/apt/sources.list && \
    apt update && \
    apt install -y net-tools iputils-ping nginx curl vim keepalived rsyslog
WORKDIR /app
COPY . .
RUN cp index.html /var/www/html/index.nginx-debian.html && \
    chmod -x keepalived.conf && \
    cp keepalived.conf /etc/keepalived/keepalived.conf
# 下面这行只能在docker run时使用-privileged执行
# echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind
CMD service rsyslog start && \
    service nginx start && \
    service keepalived start && \
    bash
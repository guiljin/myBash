FROM debian:buster
WORKDIR /app
RUN echo "deb http://ftp.de.debian.org/debian buster main" > /etc/apt/sources.list && \
    apt update && apt install -y netselect git sudo && \
    git clone https://github.com/sjqlwy/ccrm.git .
COPY crm .
CMD bash ccrm.sh
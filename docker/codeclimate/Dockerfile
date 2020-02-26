FROM docker:dind
WORKDIR /root/
RUN apk add --no-cache curl make git bash jq \
    && curl -L https://github.com/codeclimate/codeclimate/archive/master.tar.gz | tar xvz \
#    && cd codeclimate-* \
#    && make install \
    && mkdir /mnt/Home
    && echo 'alias ll="ls -l"' >> /root/.bash_profile
VOLUME /mnt/Home
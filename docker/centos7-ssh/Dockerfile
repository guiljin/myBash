FROM centos:centos7
COPY .gitconfig .vimrc install_docker.sh /root/
RUN yum install -y openssh-server \
    && yum install -y inetutils-ping iproute net-tools vim git \
    && yum clean all \
    && echo '123456' | passwd --stdin root \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
    && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config \
    && echo 'export PS1="\[\e[35;1m\][\A \u@\h \W]\$\[\e[0m\]"' >> /root/.bash_profile \
    && mkdir /mnt/Home
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
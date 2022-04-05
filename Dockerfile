FROM centos:7.9.2009
RUN yum clean all && yum update -y \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
RUN mkdir /etc/ansible/
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN mkdir /opt/ansible/
RUN git clone --branch stable-2.13 --depth 1 http://github.com/ansible/ansible.git /opt/ansible/ansible
WORKDIR /opt/ansible/ansible
RUN git submodule update --init
ENV PATH /opt/ansible/ansible/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV PYTHONPATH /opt/ansible/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/ansible/library

RUN mkdir -p /app
RUN mkdir -p /app/.ssh
RUN mkdir -p /app/roles
WORKDIR /app

COPY id_rsa /app/.ssh/
RUN chmod -R 600 /app/.ssh

COPY inventoryfile /app/
COPY playbook.yml /app/
COPY roles /app/roles

CMD ansible-playbook -i inventoryfile playbook.yml
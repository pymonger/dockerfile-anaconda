##############################################################################
# build:
# docker build --rm --force-rm -t scispark/anaconda:v0.1_000 \
#       -f Dockerfile --build-arg id=$ID --build-arg gid=`id -g` .
##############################################################################

FROM docker.io/centos:7

MAINTAINER pymonger "pymonger@gmail.com"
LABEL description="Base Centos7 anaconda image"

ENV ANACONDA_URL http://repo.continuum.io/archive/Anaconda2-4.0.0-Linux-x86_64.sh
ENV DPARK_URL https://github.com/pymonger/dpark/zipball/master

ARG id
ARG gid

# create sdeploy user/group syncing uid and gid with host
RUN groupadd -r sdeploy -g ${gid} && useradd -u ${id} -r -g sdeploy -d /home/sdeploy -s /bin/bash -m sdeploy

# update and install packages needed for anaconda installation
RUN yum update -y; \
    yum install -y wget bzip2 gcc;

# run as sdeploy user
USER sdeploy
WORKDIR /home/sdeploy

# install anaconda
RUN wget -P /tmp ${ANACONDA_URL}; \
    chmod 755 /tmp/$(basename ${ANACONDA_URL}); \
    /tmp/$(basename ${ANACONDA_URL}) -b -f -p /home/sdeploy/anaconda; \
    rm -f /tmp/$(basename ${ANACONDA_URL}); \
    echo "export PATH=$HOME/anaconda/bin:$PATH" >> /home/sdeploy/.bashrc

# install dpark
RUN /home/sdeploy/anaconda/bin/pip install ${DPARK_URL}
 
ENTRYPOINT ["/bin/bash", "--login"]

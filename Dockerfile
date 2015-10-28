# base.docker

FROM ubuntu:vivid

MAINTAINER Oscar Esteban <code@oscaresteban.es>

# Update packages
RUN apt-get update

# Install wget and git
RUN apt-get install -y wget curl git

# Enable neurodebian
RUN wget -O- http://neuro.debian.net/lists/vivid.de-m.full | tee /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
RUN apt-get update

# install supervisor
RUN apt-get -y install supervisor
ADD configs/docker/supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Install python-dev
RUN apt-get install -y python-dev

# Install pip
RUN apt-get install -y python-pip
RUN pip install --upgrade pip

# Install afni and fsl
RUN apt-get install -y fsl afni

# Install dependencies
RUN apt-get install -y liblapack-dev libblas-dev libpng-dev libfreetype6 libfreetype6-dev libhdf5-dev

# pyzmq
RUN apt-get install -y libzmq-dev

RUN pip install --upgrade numpy
RUN pip install -e git+https://github.com/preprocessed-connectomes-project/quality-assessment-protocol.git@master#egg=qap --user

# run container with supervisor (from scivm/scientific-python-2.7)
CMD ["/usr/bin/supervisord"]
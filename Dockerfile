FROM centos:7
 
MAINTAINER Jonathan Sparks <jsparks@cray.com>
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install wget
 
#### INSTALL MPICH ####
# Source is available at http://www.mpich.org/static/downloads/
# Build Options:
 
# See installation guide of target MPICH version
# Ex: http://www.mpich.org/static/downloads/3.2/mpich-3.2-installguide.pdf
# These options are passed to the steps below
 
ARG MPICH_VERSION="3.2"
ARG MPICH_CONFIGURE_OPTIONS="--disable-fortran"
ARG MPICH_MAKE_OPTIONS
 
# Download, build, and install MPICH.
# Note: make the root /ptmp, its not a standard root level directory.
RUN mkdir -p /tmp/mpich-src
WORKDIR /tmp/mpich-src
 
RUN wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
      && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
      && cd mpich-${MPICH_VERSION}  \
      && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
      && make ${MPICH_MAKE_OPTIONS} && make install \
      && rm -rf /tmp/mpich-src
 
#### TEST MPICH INSTALLATION ####
 
#### CLEAN UP ####
WORKDIR /
RUN rm -rf /tmp/*
 
# Get the benchmark codes
RUN mkdir -p /ptmp/git/ULHPC
WORKDIR /ptmp/git/ULHPC
RUN git clone https://github.com/ULHPC/launcher-scripts.git
RUN mkdir /ptmp/TP
WORKDIR /ptmp/TP
RUN wget http://www.nersc.gov/assets/Trinity--NERSC-8-RFP/Benchmarks/July12/osu-micro-benchmarks-3.8-July12.tar \
      && tar xvf osu-micro-benchmarks-3.8-July12.tar \
      && cd osu-micro-benchmarks-3.8-July12 \
      && ./configure \
      && make && make install

RUN echo /u/staff/hwleong/craylibs >> /etc/ld.so.conf

CMD ["/bin/bash"]

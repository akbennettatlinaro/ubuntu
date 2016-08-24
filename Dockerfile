#
# Zephyr Build Container
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:16.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get install -y git make gcc g++ python3-ply ncurses-dev lib32z1 lib32ncurses5 && \
  apt-get install -y apache2 python && \
  rm -rf /var/www/html/index.html && \
  rm -rf /var/lib/apt/lists/*

# Setup Build Enviroment
ENV LANG C
ENV ZEPHYR_BASE /root/zephyr-project
ENV GCCARMEMB_TOOLCHAIN_PATH /root/gcc-arm-none-eabi-5_4-2016q2
ENV ZEPHYR_GCC_VARIANT gccarmemb
ENV CROSS_COMPILE /root/gcc-arm-none-eabi-5_4-2016q2/bin/arm-none-eabi-

# Build.
RUN \
  cd /root && \
  wget https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q2-update/+download/gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2 && \
  tar -C . -xaf gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Copy build script
COPY build-zephyr.sh /root/build-zephyr.sh

# Define default command.
CMD ./build-zephyr.sh && bash

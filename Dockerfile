FROM ubuntu:22.04

WORKDIR /build

# Install packages required for build and test
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y -V \
  libmecab-dev \
  mecab-naist-jdic \
  git \
  ruby \
  ruby-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata

COPY ./groonga/setup.sh /build/setup.sh
RUN /build/setup.sh

# For testing Apache Arrow support
RUN gem install red-arrow

# lint
RUN apt-get install -y -V python3-pip
RUN pip3 install pre-commit

# debug
RUN apt-get install -y -V gdb


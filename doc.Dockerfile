FROM ubuntu:22.04

WORKDIR /docs

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y -V \
  ca-certificates \
  gettext \
  git \
  libmecab-dev \
  lsb-release \
  mecab-naist-jdic \
  python3-pip \
  ruby \
  ruby-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata

COPY ./groonga/setup.sh /build/setup.sh
RUN /build/setup.sh

COPY groonga/doc/requirements.txt ./requirements.txt
RUN pip3 install -r ./requirements.txt

COPY groonga/doc/Gemfile ./Gemfile
RUN gem install bundler
RUN bundle install

# for ninja doc_update_examples
RUN apt-get install -y -V \
  language-pack-ja \
  libevent-dev \
  libczmq-dev \
  libprotobuf-dev \
  psmisc

RUN git clone https://github.com/msgpack/msgpack-c.git --depth 1 --branch c_master /msgpack-c
RUN cd /msgpack-c && cmake . && make && make install
RUN rm -rf /msgpack-c

ENV LANG=ja_JP.UTF-8

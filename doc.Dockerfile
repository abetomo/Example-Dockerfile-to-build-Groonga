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
  ruby-dev \
  wget
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata

COPY ./groonga/setup.sh /build/setup.sh
RUN /build/setup.sh

RUN wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | \
  tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt-get install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN rm -f ./apache-arrow-apt-source-latest-*.deb
RUN apt-get update
RUN apt-get install -y -V libarrow-dev

COPY groonga/doc/requirements.txt ./requirements.txt
RUN pip3 install -r ./requirements.txt

COPY groonga/doc/Gemfile ./Gemfile
RUN gem install bundler
RUN bundle install

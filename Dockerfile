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

# To enable Apache Arrow support
RUN apt-get install -y -V ca-certificates lsb-release wget
RUN wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | \
  tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt-get install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt-get update
RUN apt-get install -y -V libarrow-dev
RUN gem install red-arrow

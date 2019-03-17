FROM ruby:2.6

RUN apt-get update && apt-get -y install wget build-essential libc6-dev libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev autoconf bison

RUN wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.1.tar.gz
RUN tar -xzf freetds-1.1.tar.gz
RUN cd freetds-1.1 && ./configure --prefix=/usr/local --with-tdsver=7.3 
RUN cd freetds-1.1 && make
RUN cd freetds-1.1 && make install

RUN mkdir /app
WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install -j 8

COPY . /app
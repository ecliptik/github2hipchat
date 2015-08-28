FROM ruby:2.1-onbuild
MAINTAINER Micheal Waltz <ecliptik@gmail.com>

WORKDIR /app
ADD Gemfile /app/Gemfile
RUN ["/usr/bin/bundle", "install", "--standalone"]
ADD . /app

EXPOSE 4567

CMD ["ruby", "/app/github2hipchat.rb"]

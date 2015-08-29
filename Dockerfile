FROM ruby:2.0
MAINTAINER Micheal Waltz <ecliptik@gmail.com>

#Setup environment and copy contents
WORKDIR /app
COPY [ "/", "/app" ]
RUN [ "bundle", "install", "--standalone" ]

#Expose default sinatra port
EXPOSE 4567

#Run event handler
ENTRYPOINT [ "ruby", "/app/github2hipchat.rb" ]

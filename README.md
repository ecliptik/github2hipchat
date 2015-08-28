github2hipchat
============

Event handler to handle messages from Github and publish into a Hipchat Channel.

## Installing

This event handler is meant to be run as a Docker container.

1. Install dependencies, this only needs to be done once:

        docker run --rm -v "$(pwd)":/app -w /app google/ruby sh -c 'bundle install --standalone'

2. Modify the *hipchat_config.yml* configuration and update the **hipchat_room** and **hipchat_auth_token** values to match your configuration.

An example configuration is below:

        hipchat_api_url: 'https://hipchat.atlassian.com'
        hipchat_auth_token: '123afdfa3234fadsfasdf3q2asdfasdf43asdf'
        hipchat_room: 'myroom'
        hipchat_message_color: 'yellow'
        hipchat_message_from: 'github'
        hipchat_message_format: 'html'

3. Run the container

        docker run -i -t --rm -v "$(pwd)":/app -w /app -p 4567:4567 google/ruby sh -c 'ruby github2hipchat.rb'

4. Create a github webhook in your repository to publish to your new event_handler,

        http://containerhost:4567/event_handler

## Running as Daemon

To run this container from Docker Hub, do the following:

    docker pull ecliptik/github2hipchat:latest
    docker run -t -d -p 4567:4567 ecliptik/github2hipchat:latest

## Dependencies

This event_handler is written in Ruby using the [Sinatra](http://www.sinatrarb.com/) gem and the [ruby](https://hub.docker.com/_/ruby/) base docker image.

## Workflow

The github webhook will send a JSON blob to the event_handler listening in the container, in turn this event_handler will parse the HTTP header (*HTTP_X_GITHUB_EVENT*) to determine what type of event was issued (issues, push, pull_request, etc).

Hipchat messages will be constructed based on event type, using information from the JSON blob.

To configure your own events, add or modify the code blocks to include the needed variables and add them to your message.

## Testing

The quickest way to test is to comment out all URI/HTTP statements and add a *puts hipchat_payload* after the even code blocks. Startup the container, and re-issue a webhook from your repository. The event_handler will recieve the JSON blob, and then output the **hipchat_payload** message to the container console.


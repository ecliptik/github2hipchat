# github2hipchat

Event handler to handle messages from [Github](https://www.github.com) and publish into a [Hipchat](https://www.hipchat.com/) channel.

## Installing

This event handler is meant to be run as a [Docker](https://www.docker.com/) container.

- Modify the *hipchat_config.yml* configuration and update the **hipchat_room** and **hipchat_auth_token** values to match your configuration.

An example configuration is below:
```
hipchat_api_url: 'https://hipchat.atlassian.com'
hipchat_auth_token: '1234567890abcdefghijklmnopqrstuvwxyz'
hipchat_room: 'myroom'
hipchat_message_color: 'yellow'
hipchat_message_from: 'github'
hipchat_message_format: 'html'
```

- Build the container image named *github2hipchat*
```
docker build -t github2hipchat .
```

- Run the container as a daemon, exposing port 4567
```
docker run -d -p 4567:4567 github2hipchat
```

- Create a github webhook in your repository to publish to your new event_handler,
```
http://containerhost:4567/event_handler
```

## Dependencies

The event_handler is written in Ruby using the [Sinatra](http://www.sinatrarb.com/) gem and the [ruby](https://hub.docker.com/_/ruby/) base docker image.

## Workflow

The github webhook will send a JSON blob to the event_handler listening in the container, in turn this event_handler will parse the HTTP header (*HTTP_X_GITHUB_EVENT*) to determine what type of event was issued (issues, push, pull_request, etc).

Hipchat messages will be constructed based on event type, using information from the JSON blob.

To configure your own events, add or modify the code blocks to include the needed variables and add them to your message.

## Testing

The quickest way to test is to comment out all URI/HTTP statements and add a *puts hipchat_payload* after the even code blocks. Startup the container, and re-issue a webhook from your repository. The event_handler will recieve the JSON blob, and then output the **hipchat_payload** message to the container console.

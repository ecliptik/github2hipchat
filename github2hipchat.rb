#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'bundle/bundler/setup'
require 'sinatra'
require 'json'
require 'yaml'
require 'hipchat'

# Bind Sinatra to all interfaces on port 4567
set :bind, '0.0.0.0'
set :port, 4567

# send2hipchat function to emit a message to channel
# Accepts message and color string
def send2hipchat(message, color = "yellow")
  @message = message
  @color = color

  # Load in our config
  hipchat_config = YAML.load_file('hipchat_config.yml')

  # Setup our hipchat API connection
  puts ' [' + Time.now.strftime('%b %d %T.%2N') + "] Sending message #{@message} to hipchat channel #{hipchat_config['hipchat_room']}"
  hp = HipChat::Client.new(hipchat_config['hipchat_auth_token'],
                           api_version: 'v2',
                           server_url:  hipchat_config['hipchat_api_url'])

  hp[hipchat_config['hipchat_room']].send(hipchat_config['hipchat_message_from'],
                                          @message,
                                          color: @color,
                                          message_format: hipchat_config['hipchat_message_format'])
end

puts '[' + Time.now.strftime('%b %d %T.%2N') + '] Starting up...'

# Set an event_handler for sinatra to point a github webhook to
post '/event_handler' do

  # Read in JSON payload from github
  payload = JSON.parse(request.body.read)
  sender = payload['sender']['login']
  senderurl = payload['sender']['html_url']

  # Determine the event type a build an appropriate message
  case request.env['HTTP_X_GITHUB_EVENT']
  when 'pull_request'
    pullurl = payload['pull_request']['html_url']
    pulltitle = payload['pull_request']['title']
    state = payload['pull_request']['state']
    reponame = payload['repository']['full_name']
    repourl = payload['repository']['html_url']

    if payload['action'] == 'opened'
      color = 'green'
    elsif payload['action'] == 'closed'
      color = 'red'
    end

    # Construct the message
    message = "[<b><a href=\"#{repourl}\">#{reponame}</a></b>] pull request #{state} by <a href=\"#{senderurl}\">#{sender}</a></br><a href=\"#{pullurl}\">#{pulltitle}</a>"

  #Send message to hipchat
  send2hipchat(message, color)

  end

end

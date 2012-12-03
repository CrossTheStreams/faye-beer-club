require 'rubygems'
require 'bundler'
Bundler.require
require 'faye'

require File.expand_path('../config/initializers/faye_token.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['ext']['auth_token'] != FAYE_TOKEN
      message['error'] = 'Invalid authentication token'
    end
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45, :extensions => [ServerAuth.new])
run faye_server

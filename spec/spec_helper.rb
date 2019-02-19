require 'simplecov'

# Start SimpleCov
SimpleCov.start do
  add_filter 'spec/'
end

# Load Rails dummy app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)

# Load test gems
require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner'

# Load our own config
require_relative 'config_rspec'

class Email
  attr_accessor :address
end

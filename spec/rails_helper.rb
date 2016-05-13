require 'simplecov'
require 'codeclimate-test-reporter'

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
])

SimpleCov.start 'rails' do
  add_filter do |source_file|
    source_file.filename.to_s == File.expand_path('../../lib/active_use_case/version.rb', __FILE__).to_s
  end
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../spec/dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'database_cleaner'

## Configure RSpec
RSpec.configure do |config|
  # Include standard helpers
  config.include FactoryGirl::Syntax::Methods

  config.color = true
  config.fail_fast = false

  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    # FactoryGirl.lint
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end


class Email
  attr_accessor :address
end


module Comments
  class SendEmail  < ActiveUseCase::Base
    def execute(email)
    end
  end
end

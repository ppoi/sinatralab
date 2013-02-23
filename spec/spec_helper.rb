ENV['RACK_ENV'] = "test" unless ENV['RACK_ENV']
require File.expand_path('../config/boot', File.dirname(__FILE__))


if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start do
    add_filter '/gems/'
    add_filter '/config/'
    add_filter '/spec/'
  end
end

require 'lilac-api'


RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include FactoryGirl::Syntax::Methods

  conf.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { except: [:schema_info] }
  end

  conf.before(:each) do
    DatabaseCleaner.start
  end

  conf.after(:each) do
    DatabaseCleaner.clean
  end
end

FactoryGirl.find_definitions



def app
  @app ||= LilacAPI::Application
end


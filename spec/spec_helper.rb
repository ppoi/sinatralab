ENV['RACK_ENV'] = "test" unless ENV['RACK_ENV']
require File.expand_path('../config/boot', File.dirname(__FILE__))

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


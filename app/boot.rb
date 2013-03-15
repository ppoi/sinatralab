APP_ENVIRONMENT = (ENV['RACK_ENV'] || 'development').to_sym unless defined?(APP_ENVIRONMENT)
APP_ROOT = File.expand_path('../..', __FILE__)

$:.unshift "#{APP_ROOT}/app".untaint

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, APP_ENVIRONMENT)

require 'logging'

Sequel::Model.plugin :schema
Sequel::Model.plugin :json_serializer, :naked=>true
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure

require "#{APP_ROOT}/config/settings"


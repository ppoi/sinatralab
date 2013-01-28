require 'rubygems'
require 'bundler/setup'
LILAC_ENVIRONMENT = (ENV['RACK_ENV'] || 'develop').to_sym
p LILAC_ENVIRONMENT
Bundler.require(:default, LILAC_ENVIRONMENT)

require File.expand_path('../database.rb', __FILE__)
require File.expand_path('../../app/lilac-api', __FILE__)


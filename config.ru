require File.expand_path("../app/boot.rb", __FILE__)
require 'controllers/service'
require 'controllers/label'
require 'controllers/auth'

run LilacAPI::Application

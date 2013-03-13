require File.expand_path("../app/boot.rb", __FILE__)
require 'controllers/service'
require 'controllers/label'

run LilacAPI::Application

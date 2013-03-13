
module LilacAPI
  class Application < Sinatra::Base
    configure :development do |config|
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end
    configure do
      helpers Sinatra::JSON
      set :public_folder, File.expand_path('../../public', __FILE__)
      set :json_encoder, :to_json
      register Sinatra::Namespace
      use Rack::PostBodyContentTypeParser
      set :logging, true
    end
  end
end


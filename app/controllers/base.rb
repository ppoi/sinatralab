
module LilacAPI
  class Application < Sinatra::Base
    configure :development, :test do |config|
      logs.debug "loading Sinatra::Reloader"
      require 'sinatra/reloader'
      register Sinatra::Reloader
      logs.debug  "#{APP_ROOT}/app/**/*"
      also_reload "#{APP_ROOT}/app/**/*"
    end
    configure do
      helpers Sinatra::JSON
      set :public_folder, File.expand_path('../../public', __FILE__)
      set :json_encoder, :to_json
      enable :sessions
      register Sinatra::Namespace
      use Rack::PostBodyContentTypeParser
      use OmniAuth::Builder do
        require 'omniauth/strategies/twitter-restricted'
        provider :twitter_restricted, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
      end
    end
  end
end


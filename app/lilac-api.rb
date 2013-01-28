
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
    end
  end
end

module_paths = ['models', 'helpers', 'controllers']
module_paths.each do |path|
  Dir.glob "#{APP_ROOT}/app/#{path}/**/*.rb" do |file|
    require file
  end
end

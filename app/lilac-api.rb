
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
    end
  end
end

app_root = File.expand_path('../', __FILE__)
module_paths = ['models', 'helpers', 'controllers']
module_paths.each do |path|
  Dir.glob "#{app_root}/#{path}/**/*.rb" do |file|
    require file
  end
end

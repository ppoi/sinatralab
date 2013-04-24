require 'lilac/models/common'
require 'lilac/models/bibliography'

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

    get '/' do
      json({
        label: "/label",
        booksearch: "/booksearch"
      })
    end

    namespace '/auth' do
      get '/twitter/callback' do
         auth_hash = env['omniauth.auth']
         logs.debug "==RAW INFO========="
         logs.debug auth_hash.extra.raw_info
         logs.debug "==INFO============="
         logs.debug auth_hash.info
         logs.debug "==SESSION=========="
         logs.debug session
         logs.debug "-----"
         logs.debug auth_hash

         username = params['username']
         screen_name = auth_hash.extra.raw_info['screen_name']
         user_id = auth_hash.extra.raw_info['id']
         account = Lilac::Models::Account[username]
         if account.nil?
            return 401
         end
         credential = account.credential
         if not credential.nil? and credential.user_id != user_id
           return 401
         end
         account.credential = {screen_name: screen_name, user_id: user_id}
         return "OK"
      end
    end

    namespace '/label' do
      get do
        entities = Lilac::Models::Label.all
        json entities
      end

      get '/:label_id' do
        entity = Lilac::Models::Label[params[:label_id]]
        if entity.nil?
          404
        else
          json entity
        end
      end

      put nil do
        entity = Lilac::Models::Label.new
        entity.name = params["name"] if params.key?("name")
        entity.website = params["website"] if params.key?("website")
        entity.publisher = params["publisher"] if params.key?("publisher")
        entity.note = params["note"] if params.key?("note")
        entity.save
        json entity
      end

      post '/:label_id' do
        entity = Lilac::Models::Label[params[:label_id]]
        if entity.nil?
          404
        else
          entity.name = params["name"] if params.key?("name")
          entity.website = params["website"] if params.key?("website")
          entity.publisher = params["publisher"] if params.key?("publisher")
          entity.note = params["note"] if params.key?("note")
          entity.save
          json entity
        end
      end

      delete '/:label_id' do
        Lilac::Models::Label.where(:id=>params[:label_id]).delete
        200
      end
    end

  end
end


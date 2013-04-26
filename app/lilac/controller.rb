require 'lilac/models/common'
require 'lilac/models/bibliography'

module Lilac
  class Application < Sinatra::Base
    configure :development, :test do |config|
      logs.debug "loading Sinatra::Reloader"
      require 'sinatra/reloader'
      register Sinatra::Reloader
      also_reload "#{APP_ROOT}/app/lilac/**/*.rb"
    end
    configure do
      helpers Sinatra::JSON
      set :public_folder, File.expand_path("#{APP_ROOT}/public", __FILE__)
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
      send_file 'public/main.html', :type=>'text/html; charset=UTF-8'
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
        auth_info = {
          username: username,
          profile_image_url: auth_hash.extra.raw_info['profile_image_url']
        }
        erb :authenticated, :locals=>auth_info, :content_type=>'text/html'
      end
    end

    namespace '/api' do
      get do
        json({
          label: "/api/label",
          booksearch: "/api/booksearch"
        })
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
end


require 'lilac/models/common'
require 'lilac/models/bibliography'
require 'lilac/helpers/auth'

module Lilac
  class Application < Sinatra::Base
    configure :development, :test do |config|
      logs.debug "loading Sinatra::Reloader"
      require 'sinatra/reloader'
      register Sinatra::Reloader
      also_reload "#{APP_ROOT}/app/lilac/**/*.rb"
    end
    configure do
      helpers Sinatra::JSON, Lilac::AuthHelper
      set :public_folder, File.expand_path("#{APP_ROOT}/public", __FILE__)
      set :json_encoder, :to_json
      enable :sessions
      register Sinatra::Namespace
      use Rack::PostBodyContentTypeParser
      use OmniAuth::Builder do
        provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, :setup=>true
      end
    end

    get '/' do
      send_file 'public/main.html', :type=>'text/html; charset=UTF-8'
    end

    namespace '/auth' do
      get '/twitter/setup' do
        uid = params['uid']
        sh = params['sh']
        unless (uid.nil? or uid.empty?) and (sh.nil? or sh.empty?)
          validate_signup(uid, sh)
        end
        404
      end

      get '/twitter/callback' do
        env['rack.session.options'][:renew] = true

        uid = params['uid']
        sh = params['sh']
        auth_hash = env['omniauth.auth']
        if (uid.nil? or uid.empty?) and (sh.nil? or sh.empty?)
          authenticate(auth_hash)
        else
          signup(uid, sh, auth_hash)
        end

        nickname = auth_hash.info.nickname
        username = auth_hash.info.name
        auth_info = {
          uid: uid,
          username: username,
          nickname: nickname,
          profile_image_url: auth_hash.extra.raw_info.profile_image_url
        }
        session['auth_info'] = auth_info
        erb :authenticated, :locals=>auth_info, :content_type=>'text/html'
      end

      get '/logout' do
        env['rack.session.options'][:renew] = true
        session.delete('auth_info')
      end
    end

    namespace '/api' do
      get do
        require_role :any
        logs.debug('SESSION====================')
        logs.debug(session)

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


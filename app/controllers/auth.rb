require 'controllers/base'
require 'models/common'

module LilacAPI
  class Application
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
         account = Account[username]
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
  end
end

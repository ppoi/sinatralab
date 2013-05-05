require 'omniauth-twitter'
require 'lilac/models/common'

module OmniAuth
  module Strategies
    class TwitterRestricted < OmniAuth::Strategies::Twitter
      option :name, 'twitter'

      def request_phase
        logs.debug "Extended request_phase called!: params=#{session['omniauth.params']}"
        uid = session['omniauth.params']['uid']
        signup_hash = session['omniauth.params']['sh']
        if signup_hash and Lilac::Models::SignupEntry[uid, hash].nil?
          fail!(:invalid_signup_hash)
          return
        elsif uid.nil? or Lilac::Models::Account[uid].nil?
          fail!(:invalid_uid)
          return
        end
        super
      end
    end
  end
end

require 'omniauth-twitter'
require 'lilac/models/common'

module OmniAuth
  module Strategies
    class TwitterRestricted < OmniAuth::Strategies::Twitter
      option :name, 'twitter'

      alias :original_request_phase :request_phase
      def request_phase
        logs.debug "Extended request_phase called!"
        username = session['omniauth.params']['username']
        logs.debug "authenticate with #{username}"
        account = username ? Lilac::Models::Account[username] : nil
        if account.nil?
          logs.info "account <#{username}> is not found."
          fail!(:invalid_credentials)
          return
        end
        credential = account.credential
        session['omniauth.params']['screen_name'] = credential.screen_name unless credential.nil?
        original_request_phase
      end
    end
  end
end

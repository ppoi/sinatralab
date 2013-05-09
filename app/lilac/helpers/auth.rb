
module Lilac

  class AuthError < ::StandardError; end

  module AuthHelper

    def authenticate(auth_hash)
      credential = Lilac::Models::AccountCredential[auth_hash.uid]
      if credential.nil?
        raise Lilac::AuthError.new("Unassociated Twitter ID")
      end
      credential.update :token=>auth_hash.credentials.token, :secret=>auth_hash.credentials.secret

      account = Lilac::Models::Account[credential.account_id]
      save_auth_info(account, auth_hash)

      return account
    end

    def signup(uid, sh, auth_hash)
      entry = validate_signup(uid, sh)
      entry.delete

      account = Lilac::Models::Account[entry.id]
      if account.nil?
        account = Lilac::Models::Account.new
        account.id = entry.id
      end
      account.email_address = entry.email_address
      account.save

      credential = account.credential || Lilac::Models::AccountCredential.new
      credential.id = auth_hash.uid
      credential.token = auth_hash.credentials.token
      credential.secret = auth_hash.credentials.secret
      credential.account_id = account.id
      credential.save

      save_auth_info(account, auth_hash)

      return account
    end

    def validate_signup(uid, sh)
      if uid.nil? or uid.empty? or sh.nil? or sh.empty?
        raise Lilac::AuthError.new "Invalid Signup Parameter"
      else
        entry = Lilac::Models::SignupEntry[uid]
        if entry.nil?
          raise Lilac::AuthError.new "Invalid Signup Parameter"
        elsif sh != entry.entry_hash
          raise Lilac::AuthError.new "Invalid Signup Parameter"
        else
          current = (Time.now - (60 * 60 * 24)).strftime('%Y%m%d%H%M%S%N')
          if current > entry.registration_timestamp
            logging.info("SignupEntry expired. registration_timestamp=#{entry.registration_timestamp}, id=#{entry.id}")
            raise Lilac::AuthError.new "SingupEntry expired"
          end
        end
        return entry
      end
    end

    def require_auth(auth_type)
      auth_info = session['auth_info']
      case auth_type
      when :any then
        true
      when :authenticated then
        raise Lilac::AuthError.new("authorization insufficient") if auth_info.nil?
      when :administrator then
        raise Lilac::AuthError.new("authorization insufficient") if auth_info.nil?
      end
    end

    def auth_info
      session['lilac.auth']
    end

    def save_auth_info(account, auth_hash)
      auth_info = {
        :uid=>account.id,
        :username=>auth_hash.info.name,
        :nickname=>auth_hash.info.nickname,
        :profile_image=>auth_hash.info.image,
      }
      session['lilac.auth'] = auth_info
      auth_info
    end

    def delete_auth_info
      session.delete('lilac.auth')
    end
  end

end


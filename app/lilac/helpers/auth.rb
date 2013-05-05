
module Lilac

  module Auth
    Any = 0
    Authenticated = 1
    Administrator = 2
  end

  class AuthError < ::StandardError
  end

  module AuthHelper

    def autheticate(uid, auth_hash)
      account = Lilac::Models::Account[uid]
      if account.nil?
        logging.info("Invalid Account ID. id=#{uid}")
        raise Lilac::AuthError.new "Invalid Account ID"
      end

      if account.credential.nil?
        logging.info("Account credential not found. id=#{uid}")
        raise Lilac::AuthError.new "Account credential not found"
      end

      external_id = account.credential.external_id
      credential = create_account_credential(auth_hash, account.credential)
      if external_id != credential.external_id
        logging.info("Invalid external ID. expected '#{external_id}', but got '#{credential.external_id}'. id=#{uid}")
        raise Lilac::AuthError.new "Invalid external ID"
      end
      credential.id = uid
      credential.save
    end

    def signup(uid, signup_hash, auth_hash)
      entry = Lilac::Models::SignupEntry[uid]
      if entry.nil?
        logging.info("Invalid Account/SignupEntry id. id=#{uid}")
        raise Lilac::AuthError.new "Invalid Account/SignupEntry ID."
      elsif signup_hash != entry.entry_hash
        logging.info("Invalid SignupEntry Hash. expected '#{entry.entry_hash}', but got '#{signup_hash}'. id=#{entry.id}")
        raise Lilac::AuthError.new "Invalid SignupEntry Hash"
      else
        current = (Time.now - (60 * 60 * 24)).strftime('%Y%m%d%H%M%S%N')
        if curremt > entry.registration_timestamp
          logging.info("SignupEntry expired. registration_timestamp=#{entry.registration_timestamp}, id=#{entry.id}")
          raise Lilac::AuthError.new "SingupEntry expired"
        end
      end

      account = Lilac::Models::Account[uid] || Lilac::Models::Account.new(:id=>uid)
      account.email_address = entry.email_address
      account.save

      credential = create_account_credential(auth_hash account.credential)
      credential.id = uid
      credential.save
    end

    def require_role(*args)
    end

    def create_account_credential(auth_hash, credential)
      credential ||= Lilac::Models::AccountCredental.new
      credential.access_token = auth_hash.extra.access_token.token
      credential.access_secret = auth_hash.extra.access_token.secret
      credential.external_id = auth_hash.extra.raw_info.id
      credential
    end
  end

end


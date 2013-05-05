require 'digest'
require 'securerandom'

module Lilac
  module Models

    class SignupEntry < Sequel::Model

      def entry_hash
        Digest::SHA512.hexdigest("#{self.id}:#{self.email_address}:#{self.registration_timestamp}")
      end

      def before_create
        #同じE-mailアドレスで登録申請があった場合、過去の申請情報を削除
        duplication_check = SignupEntry.where(:email_address=>self.email_address)
        if duplication_check.count
          duplication_check.delete
        end
        # アカウントUUID
        self.id = SecureRandom.uuid if self.id.nil?
        #登録タイムスタンプ
        self.registration_timestamp = Time.now.strftime('%Y%m%d%H%M%S%N')
      end
    end

    class Account < Sequel::Model
      plugin :optimistic_locking
      one_to_one :credential, :class=>'Lilac::Models::AccountCredential', :key=>:id
    end

    class AccountCredential < Sequel::Model
    end

  end
end

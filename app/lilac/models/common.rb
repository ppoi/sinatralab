
module Lilac
  module Models

    class Account < Sequel::Model

      def credential
        @credential ||= AccountCredential[name]
      end

      def credential!
        @credential = AccountCredential[name]
      end

      def credential=(args={})
        if not args
          AccountCredential[name].delete
          @credential = nil
        else
          credential = @credential || AccountCredential[name]
          if credential.nil?
            credential = AccountCredential.new
            credential.name = name
          end
          credential.screen_name = args[:screen_name]
          credential.user_id = args[:user_id]
          credential.save
          @credential = credential
        end
      end
    end

    class AccountCredential < Sequel::Model
    end

  end
end

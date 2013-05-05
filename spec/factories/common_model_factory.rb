require 'lilac/models/common'
require 'securerandom'

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :signup_entry, class: Lilac::Models::SignupEntry do
    email_address "miku@example.com"
  end

  factory :account, :class=>Lilac::Models::Account do
    id {SecureRandom.uuid}
    email_address 'miku@example.com'
  end

  factory :account_credential, :class=>Lilac::Models::AccountCredential do
    access_token = '3939-mikumiku'
    access_secret = 'hatsunemiku'
    external_id 39
  end

end

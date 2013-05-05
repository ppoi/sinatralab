require 'omniauth/strategies/twitter_restricted'

FactoryGirl.define do
  to_create {|instance| request.env['omniauth.auth'] = instance}

  factory :auth_hash, :class=>OmniAuth::AuthHash do
  end

  factory :credential, :class=>OAuth::AccessToken do
  end
end

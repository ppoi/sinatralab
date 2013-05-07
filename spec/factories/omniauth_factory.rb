

FactoryGirl.define do

  factory :auth_hash, :class=>OmniAuth::AuthHash do
  end

  factory :credential, :class=>OAuth::AccessToken do
  end
end

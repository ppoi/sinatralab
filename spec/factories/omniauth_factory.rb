

FactoryGirl.define do

  factory :auth_hash, :class=>OmniAuth::AuthHash do
    provider 'twitter'
    uid '39'
    association :info, :factory=>:auth_hash_info, :strategy=>:build
    association :credentials, :factory=>:auth_hash_credentials, :strategy=>:build
  end

  factory :auth_hash_info, :class=>OmniAuth::AuthHash::InfoHash do
    name 'Miku Hatsune'
    nickname 'miku'
    image 'negi.jpg'
  end

  factory :auth_hash_credentials, :class=>OmniAuth::AuthHash do
    token '39-mikumiku'
    secret 'mikumikumiku'
  end
end

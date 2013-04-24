require 'lilac/models/common'

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :account, class: Lilac::Models::Account do
    name "user"
    realname {name.upcase}
    email_address {"#{name}@localhost"}
  end

  factory :credential, class: Lilac::Models::AccountCredential do
    name "user"
    screen_name {name}
    user_id 39
  end
end

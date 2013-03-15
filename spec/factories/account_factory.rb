require 'models/common'

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :account do
    name "user"
    realname {name.upcase}
    email_address {"#{name}@localhost"}
  end

  factory :credential, class: AccountCredential do
    name "user"
    screen_name {name}
    user_id 39
  end
end

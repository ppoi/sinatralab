# -*- encoding: utf-8 -*-

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :dengeki, class: Label do
    #id 1
    name '電撃文庫'
    website 'http://dengekibunko.dengeki.com/'
    publisher 'アスキー・メディアワークス'
  end

  factory :label_n, class: Label do
    #sequence(:id, 1000) {|n| }
    sequence(:name, 1) {|n| "レーベル#{n}"}
  end

end

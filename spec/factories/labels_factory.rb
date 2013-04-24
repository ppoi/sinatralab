# -*- encoding: utf-8 -*-
require 'lilac/models/bibliography'

FactoryGirl.define do
  to_create {|instance| instance.save}

  factory :dengeki, class: Lilac::Models::Label do
    #id 1
    name '電撃文庫'
    website 'http://dengekibunko.dengeki.com/'
    publisher 'アスキー・メディアワークス'
  end

  factory :label_n, class: Lilac::Models::Label do
    #sequence(:id, 1000) {|n| }
    sequence(:name, 1) {|n| "レーベル#{n}"}
  end

end

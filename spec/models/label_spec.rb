# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'lilac/models/bibliography'

describe "Lilac::Models::Label" do

  it 'return nil by non-existing id' do
    Lilac::Models::Label[3939].should be_nil
  end

  it 'return nil by non-existing name' do
    create :dengeki
    Lilac::Models::Label.get('Orphan').should be_nil
  end

  it 'can find by id' do
    create :dengeki
    label = Lilac::Models::Label[1]
    label.should_not be_nil
    label.id.should == 1
    label.name.should == "電撃文庫"
    label.website.should == 'http://dengekibunko.dengeki.com/'
    label.publisher.should == 'アスキー・メディアワークス'
    label.note.should == ''
  end

  it 'can find by name' do
    create :dengeki
    label = Lilac::Models::Label.get "電撃文庫"
    label.should_not be_nil
    label.id.should == 1
    label.website.should == 'http://dengekibunko.dengeki.com/'
    label.publisher.should == 'アスキー・メディアワークス'
    label.note.should == ''
  end

  it 'can save with auto incremented id' do
    label = Lilac::Models::Label.new(:name=>"レーベル1")
    label.id.should be_nil
    label.save
    label.id.should_not be_nil
    Lilac::Models::Label[label.id].should_not be_nil
  end

  it 'return empty list if no record exists' do
    list = Lilac::Models::Label.all
    list.should_not be_nil
    list.should have(0).items
  end

  it 'can list order by name' do
     Lilac::Models::Label.new(:name=>"レーベル1").save
     Lilac::Models::Label.new(:name=>"レーベル3").save
     Lilac::Models::Label.new(:name=>"レーベル2").save
     Lilac::Models::Label.new(:name=>"レーベル4").save

     list = Lilac::Models::Label.all
     list.should_not be_nil
     list.should have(4).items
     list[0].name.should == 'レーベル1'
     list[1].name.should == 'レーベル2'
     list[2].name.should == 'レーベル3'
     list[3].name.should == 'レーベル4'
  end
end

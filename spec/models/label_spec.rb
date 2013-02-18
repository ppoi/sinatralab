# -*- encoding: utf-8 -*-

describe "Label Model" do

  it 'return nil by non-existing id' do
    Label[3939].should be_nil
  end

  it 'return nil by non-existing name' do
    create :dengeki
    Label.get('Orphan').should be_nil
  end

  it 'can find by id' do
    create :dengeki
    label = Label[1]
    label.should_not be_nil
    label.id.should == 1
    label.name.should == "電撃文庫"
    label.website.should == 'http://dengekibunko.dengeki.com/'
    label.publisher.should == 'アスキー・メディアワークス'
    label.note.should == ''
  end

  it 'can find by name' do
    create :dengeki
    label = Label.get "電撃文庫"
    label.should_not be_nil
    label.id.should == 1
    label.website.should == 'http://dengekibunko.dengeki.com/'
    label.publisher.should == 'アスキー・メディアワークス'
    label.note.should == ''
  end

  it 'can save with auto incremented id' do
    label = Label.new(:name=>"レーベル1")
    label.id.should be_nil
    label.save
    label.id.should_not be_nil
    Label[label.id].should_not be_nil
  end

  it 'return empty list if no record exists' do
    list = Label.all
    list.should_not be_nil
    list.should have(0).items
  end

  it 'can list order by name' do
     Label.new(:name=>"レーベル1").save
     Label.new(:name=>"レーベル3").save
     Label.new(:name=>"レーベル2").save
     Label.new(:name=>"レーベル4").save

     list = Label.all
     list.should_not be_nil
     list.should have(4).items
     list[0].name.should == 'レーベル1'
     list[1].name.should == 'レーベル2'
     list[2].name.should == 'レーベル3'
     list[3].name.should == 'レーベル4'
  end
end

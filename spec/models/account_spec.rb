require 'spec_helper'
require 'lilac/models/common'

describe "Lilac::Models::Account Model" do
  it "return null by non-exists id" do
    Lilac::Models::Account['foobar'].should be_nil
  end

  it "get by id" do
    create :account, name: 'user1'
    account = Lilac::Models::Account['user1']
    account.should_not be_nil
    account.name.should eq('user1')
    account.email_address.should eq('user1@localhost')
  end

  it "has no credential by default" do
    create :account, name: 'user1'
    account = Lilac::Models::Account['user1']
    account.credential.should be_nil
  end

  it "create default credential" do
    account = create :account, name: 'user1'
    account.credential = {screen_name: "ppoi", user_id: 123}
    account.credential.should_not be_nil
    account.credential.name.should eq('user1')
    account.credential.screen_name.should eq('ppoi')
    account.credential.user_id.should eq(123)
  end

  it "cache credential" do
    account = create :account
    credential = create :credential, {name: account.name, screen_name: 'ppoi', user_id: 39}

    c1 = account.credential
    c1.should_not be_nil
    c1.should_not be(credential)
    c2 = account.credential
    c1.should be(c2)
  end

  it "update credential with cache" do
    account = create :account
    credential = create :credential, {name: account.name, screen_name: 'ppoi', user_id: 39}

    c1 = account.credential
    c1.should_not be_nil
    c1.should_not be(credential)
    account.credential = {screen_name: 'lilac', user_id:3939}
    c2 = account.credential
    c1.should be(c2)
  end

  it "can reload credential" do
    account = create :account
    credential = create :credential, {name: account.name, screen_name: 'ppoi', user_id: 39}

    c1 = account.credential
    c1.should_not be_nil
    c1.should_not be(credential)
    c2 = account.credential!
    c1.should_not be(c2)
  end
end

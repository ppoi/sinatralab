require 'spec_helper'
require 'lilac/helpers/auth'

module AuthHelperSpec
  class App
    include Lilac::AuthHelper

    def initialize(env={})
      @env = env
      @request = Rack::Request.new(env)
    end

    def env
      @env
    end

    def request
      @request
    end

    def session
      @request.session
    end
  end
end


describe 'AuthHelper' do

  it 'authenticate normal' do
    account = create :account
    account.credential = build :account_credential

    auth_hash = build :auth_hash
    helpers = AuthHelperSpec::App.new 'omniauth.auth'=>auth_hash
    result = helpers.authenticate
    result.should_not be_nil
    result.id.should eq account.id
    result.credential.id.should eq auth_hash.uid
    result.credential.token.should eq auth_hash.credentials.token
    result.credential.secret.should eq auth_hash.credentials.secret

    helpers.auth_info.should_not be_nil
    helpers.auth_info[:uid].should eq result.id
    helpers.auth_info[:username].should eq auth_hash.info.name
    helpers.auth_info[:nickname].should eq auth_hash.info.nickname
    helpers.auth_info[:profile_image].should eq auth_hash.info.image
  end

  it 'authenticate unassociate Twitter ID' do
    account = create :account
    account.credential = build :account_credential, :id=>'393'

    auth_hash = build :auth_hash
    helpers = AuthHelperSpec::App.new 'omniauth.auth'=>auth_hash
    expect {
      helpers.authenticate
    }.to raise_error Lilac::AuthError, "Unassociated Twitter ID"
  end

  it 'authenticate non-signuped account' do
    auth_hash = build :auth_hash
    helpers = AuthHelperSpec::App.new 'omniauth.auth'=>auth_hash
    expect {
      helpers.authenticate
    }.to raise_error Lilac::AuthError, "Unassociated Twitter ID"
  end

  it 'sinup normal' do
    entry = create :signup_entry

    auth_hash = build :auth_hash
    helpers = AuthHelperSpec::App.new 'omniauth.auth'=>auth_hash
    result = helpers.signup entry.id, entry.entry_hash

    result.should_not be_nil
    result.id.should eq entry.id
    result.email_address.should eq entry.email_address
    result.credential.should_not be_nil
    result.credential.id.should eq auth_hash.uid
    result.credential.token.should eq auth_hash.credentials.token
    result.credential.secret.should eq auth_hash.credentials.secret

    helpers.auth_info.should_not be_nil
    helpers.auth_info[:uid].should eq result.id
    helpers.auth_info[:username].should eq auth_hash.info.name
    helpers.auth_info[:nickname].should eq auth_hash.info.nickname
    helpers.auth_info[:profile_image].should eq auth_hash.info.image

    Lilac::Models::SignupEntry[entry.id].should be_nil
  end

  it 'resignup' do
    account = create :account
    entry = create :signup_entry, :id=>account.id
    entry.id.should eq account.id

    auth_hash = build :auth_hash
    helpers = AuthHelperSpec::App.new 'omniauth.auth'=>auth_hash
    result = helpers.signup entry.id, entry.entry_hash

    result.should_not be_nil
    result.id.should eq entry.id
    result.email_address.should eq entry.email_address
    result.credential.should_not be_nil
    result.credential.id.should eq auth_hash.uid
    result.credential.token.should eq auth_hash.credentials.token
    result.credential.secret.should eq auth_hash.credentials.secret

    helpers.auth_info.should_not be_nil
    helpers.auth_info[:uid].should eq result.id
    helpers.auth_info[:username].should eq auth_hash.info.name
    helpers.auth_info[:nickname].should eq auth_hash.info.nickname
    helpers.auth_info[:profile_image].should eq auth_hash.info.image

    Lilac::Models::SignupEntry[entry.id].should be_nil
  end

  it 'validate_signup to invalid hash' do
    entry = create :signup_entry

    expect {
      AuthHelperSpec::App.new.validate_signup entry.id, 'hoge'
    }.to raise_error Lilac::AuthError, "Invalid Signup Parameter"
  end

  it 'validate_signup to invalid uid' do
    entry = create :signup_entry

    expect {
      AuthHelperSpec::App.new.validate_signup '3939', entry.entry_hash
    }.to raise_error Lilac::AuthError, "Invalid Signup Parameter"
  end

  it 'validate_signup to expired' do
    entry = create :signup_entry
    entry.update :registration_timestamp=>'20130509170000393939393'

    expect {
      AuthHelperSpec::App.new.validate_signup entry.id, entry.entry_hash
    }.to raise_error Lilac::AuthError, "Signup expired"
  end

  it 'auth_info before authenticate' do
    AuthHelperSpec::App.new.auth_info.should be_nil
  end

  it 'delete auth_info' do
    account = create :account
    account.credential = build :account_credential
    auth_hash = build :auth_hash

    helpers = AuthHelperSpec::App.new
    helpers.save_auth_info account, auth_hash
    helpers.auth_info.should_not be_nil
    helpers.delete_auth_info
    helpers.auth_info.should be_nil
  end
end

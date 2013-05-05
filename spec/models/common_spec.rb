require 'spec_helper'

describe 'Common models' do

  describe 'SignupEntry' do
    it 'set registration timestamp on save' do
      entry = create :signup_entry
      entry.id.should.should_not be_nil
      entry.email_address.should eq 'miku@example.com'
      entry.registration_timestamp.should_not be_nil
    end

    it 'overwrite auto-generation properties on save' do
      entry = build :signup_entry
      entry.id = '3939'
      entry.registration_timestamp = '2013030903093939393939'
      entry.save
      entry.id.should eq '3939'
      entry.email_address.should eq 'miku@example.com'
      entry.registration_timestamp.should_not eq '2013030903093939393939'
    end

    it 'clear duplication entry on save' do
      entry = create :signup_entry
      Lilac::Models::SignupEntry.count.should eq 1
      entry2 = create :signup_entry
      entry2.id.should_not eq entry.id
      Lilac::Models::SignupEntry.count.should eq 1
      Lilac::Models::SignupEntry[entry.id].should be_nil
    end

    it 'can update without overwrite registration timestamp' do
      entry = create :signup_entry

      entry2 = Lilac::Models::SignupEntry[entry.id]
      entry2.email_address = 'miku2@example.com'
      entry2.save

      entry2.id.should eq entry.id
      entry2.registration_timestamp.should eq entry.registration_timestamp
    end

    it 'compute hash' do
      require 'digest'
      entry = build :signup_entry
      entry.id = '39'
      entry.registration_timestamp = '20130309030939393939393'
      entry.entry_hash.should eq Digest::SHA512.hexdigest("39:miku@example.com:20130309030939393939393")
    end
  end

  describe 'Accout' do
    it 'associate credential' do
      account = create :account
      Lilac::Models::AccountCredential[account.id].should be_nil

      account.credential = build :account_credential
      credential = Lilac::Models::AccountCredential[account.id]
      credential.should_not be_nil
      credential.id.should eq account.id
    end

    it 'delete associated credential' do
      account = create :account
      account.credential = build :account_credential
      account.credential(true).id.should eq account.id
      account.credential.delete
      account.credential(true).should be_nil
    end
  end

end

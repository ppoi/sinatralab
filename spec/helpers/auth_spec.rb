require 'spec_helper'
require 'lilac/helpers/auth'

describe 'AuthHelper' do

  it 'authenticate' do
    account = create :account
    account.credential = build :account_credential
    logging.debug OmniAuth.config.mock_auth[:twitter]
  end

end

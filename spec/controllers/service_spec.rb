require 'spec_helper'

describe 'Service API' do
  describe 'Index: GET /' do
    it 'return successfully' do
      get '/'
      last_response.should be_ok
    end
  end
end

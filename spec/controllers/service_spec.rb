require 'spec_helper'

describe 'Service API' do
  describe 'Index: GET /' do
    it 'return successfully' do
      get '/'
      last_response.should be_ok
      last_response.body.should eq("Lilac API")
    end
  end
end

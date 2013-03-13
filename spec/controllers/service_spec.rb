require 'spec_helper'
require 'controllers/service'
require 'json'

describe 'Service API' do
  describe 'Index: GET /' do
    it 'return successfully' do
      get '/'
      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result.should have(2).items
      result["label"].should eq("/label")
      result["booksearch"].should eq("/booksearch")
    end
  end
end

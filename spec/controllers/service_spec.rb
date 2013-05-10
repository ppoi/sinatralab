require 'spec_helper'
require 'lilac/controller'
require 'json'

describe 'Service API' do
  describe 'Index: GET /api' do
    it 'return successfully' do
      get '/api'
      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result.should have(2).items
      result["label"].should eq("/api/label")
      result["booksearch"].should eq("/api/booksearch")
    end
  end
end

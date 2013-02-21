require 'spec_helper'
require 'json'

describe "Label API" do

  describe 'List: GET /label' do
    it "retun empty list" do
      get '/label'
      last_response.should be_ok
      last_response.body.should eq('[]')
    end

    it "return all labels" do
      create(:dengeki)
      create(:label_n)
      create(:label_n)
      create(:label_n)
      create(:label_n)
      get '/label'

      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result.should have(5).items
      result[0]['name'].should eq('レーベル1')
      result[1]['name'].should eq('レーベル2')
      result[2]['name'].should eq('レーベル3')
      result[3]['name'].should eq('レーベル4')
      result[4]['name'].should eq('電撃文庫')
    end
  end

  describe 'Show: GET /label/{id}' do
    it "return label info" do
      entity = create(:dengeki)
      get "/label/#{entity.id}"

      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result['id'].should eq(entity.id)
      result['name'].should eq(entity.name)
      result['website'].should eq(entity.website)
      result['publisher'].should eq(entity.publisher)
    end

    it "return status 404" do
      get "/label/39"
      last_response.status.should eq(404)
    end
  end

  describe 'Create: PUT /label' do
    it "create successfuly" do
      entity = {
        name: 'MF文庫J',
        website: 'http://www.mediafactory.co.jp/bunkoj/',
        publisher: 'メディアファクトリー'
      }
      put '/label', entity.to_json, "CONTENT_TYPE"=>"application/json"

      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result['id'].should_not be_nil
      result['name'].should eq(entity[:name])
      result['website'].should eq(entity[:website])
      result['publisher'].should eq(entity[:publisher])
    end
  end

  describe 'Modify: POST /label/{id}' do
    it 'update succcessfuly' do
      origin = create(:label_n)
      entity = {
        name: origin.name,
        website: "http://example.com",
        publisher: "テスト出版社"
      }
      post "/label/#{origin.id}", entity.to_json, "CONTENT_TYPE"=>"application/json"

      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result['id'].should eq(origin.id)
      result['name'].should eq(entity[:name])
      result['website'].should eq(entity[:website])
      result['publisher'].should eq(entity[:publisher])
    end

    it 'return status 404' do
      entity = {
        name: "レーベル1A",
        website: "http://example.com",
        publisher: "テスト出版社"
      }
      post "/label/39", entity.to_json, "CONTENT_TYPE"=>"application/json"

      last_response.status.should eq(404)
    end
  end

  describe 'Delete: DELETE /label/{id}' do
    it 'delete successfuly' do
      entity = create(:label_n)
      delete "/label/#{entity.id}"

      last_response.should be_ok
    end

    it 'delete successfuly also not exists' do
      delete "/label/39"

      last_response.should be_ok
    end
  end
end

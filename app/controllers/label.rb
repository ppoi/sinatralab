require 'controllers/base'
require 'models/label'

module LilacAPI
  class Application
    namespace '/label' do
      get do
        entities = Label.all
        json entities
      end

      get '/:label_id' do
        entity = Label[params[:label_id]]
        if entity.nil?
          404
        else
          json entity
        end
      end

      put nil do
        entity = Label.new
        entity.name = params["name"] if params.key?("name")
        entity.website = params["website"] if params.key?("website")
        entity.publisher = params["publisher"] if params.key?("publisher")
        entity.note = params["note"] if params.key?("note")
        entity.save
        json entity
      end

      post '/:label_id' do
        entity = Label[params[:label_id]]
        if entity.nil?
          404
        else
          entity.name = params["name"] if params.key?("name")
          entity.website = params["website"] if params.key?("website")
          entity.publisher = params["publisher"] if params.key?("publisher")
          entity.note = params["note"] if params.key?("note")
          entity.save
          json entity
        end
      end

      delete '/:label_id' do
        Label.where(:id=>params[:label_id]).delete
        200
      end
    end
  end
end

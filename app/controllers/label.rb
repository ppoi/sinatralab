
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
          p "not found"
          404
        else
          json entity
        end
      end
    end
  end
end

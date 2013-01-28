
module LilacAPI
  class Application
    get '/label' do
      entities = Label.all
      json entities
    end
  end
end

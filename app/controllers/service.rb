
module LilacAPI
  class Application
    get '/' do
      json({
        label: "/label",
        booksearch: "/booksearch"
      })
    end

  end
end

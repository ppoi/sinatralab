require 'controllers/base'

module LilacAPI
  class Application
    get '/' do
      logs.debug "==SESSION============================================"
      logs.debug session
      logs.debug "==OMNI==============================================="
      logs.debug env['omniauth.auth']
      logs.debug "==OAUTH=============================================="
      logs.debug env
      json({
        label: "/label",
        booksearch: "/booksearch"
      })
    end

  end
end

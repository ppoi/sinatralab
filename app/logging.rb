require 'logger'
require 'singleton'

module LilacAPI

  class Logging
    include Singleton

    def initialize
      @logger ||= Logger.new(STDOUT)
    end

    def debug(msg)
      @logger.debug(msg)
    end

    def info(msg)
      @logger.info(msg)
    end

    def warn(msg)
      @logger.info(msg)
    end

    def error(msg)
      @logger.error(msg)
    end

    def fatal(msg)
      @logger.fatal(msg)
    end
  end

  def self.logger
    LilacAPI::Logging.instance
  end

end

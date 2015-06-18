module React
  module Rails
    module HotLoader
      mattr_accessor :server
      def self.start(*args)
        self.server = Server.new(*args)
        server.restart
      end

      def self.restart
        server.restart
      rescue StandardError => err
        log("failed to restart: #{err}")
      end

      def self.log(message)
        ::Rails.logger.info("[HotLoader] #{message}")
      end
    end
  end
end

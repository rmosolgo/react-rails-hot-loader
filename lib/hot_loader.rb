module React
  module Rails
    module HotLoader
      mattr_accessor :server
      mattr_accessor :port
      self.port = 8082

      # Start _or_ restart the server
      def self.restart
        self.server ||= Server.new(port: port)
        self.server.restart
      rescue StandardError => err
        React::Rails::HotLoader.error(err)
      end

      def self.log(message)
        msg = "[HotLoader] #{message}"
        ::Rails.logger.info(msg)
        ::Rails.logger.flush
      end

      def self.error(err)
        msg = "#{err.class.name}: #{err}\n #{err.backtrace.join("\n")}"
        log(msg)
      end
    end
  end
end

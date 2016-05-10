module React
  module Rails
    module HotLoader
      mattr_accessor :server

      mattr_accessor :port
      self.port = 8082

      # Create a new server with `options` & start it
      def self.start(options={})
        server_class = options.delete(:server_class) || Server
        self.server = server_class.new(options)
        restart
      end

      # Restart the server with the same options
      def self.restart
        server.present? ? server.restart : start
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

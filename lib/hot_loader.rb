module React
  module Rails
    module HotLoader
      mattr_accessor :server
      def self.start(options={})
        server_class = options.delete(:server_class) || Server
        self.server = server_class.new(options)
        server.restart
      end

      def self.restart
        server.restart
      rescue StandardError => err
        log("failed to restart: #{err}")
      end

      def self.log(message)
        msg = "[HotLoader] #{message}"
        ::Rails.logger.info(msg)
      end
    end
  end
end

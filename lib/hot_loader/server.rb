require 'em-websocket'

module React
  module Rails
    module HotLoader
      class Server
        attr_reader :host, :port, :change_set_class

        def initialize(host:  "0.0.0.0", port: 8082, change_set_class: React::Rails::HotLoader::AssetChangeSet)
          @host = host
          @port = port
          @change_set_class = change_set_class
          @thread = nil
        end

        def restart
          if @thread.blank? || @thread.stop?
            @thread = Thread.new do
              begin
                serve
              rescue StandardError => err
                React::Rails::HotLoader.log("failed to serve: #{err}\n#{err.backtrace.join("\n")}")
              end
            end
          end
        end

        def serve
          EM.run {
            React::Rails::HotLoader.log("starting WS server: ws://#{host}:#{port}")

            EM::WebSocket.run(host: host, port: port) do |ws|
              ws.onopen { React::Rails::HotLoader.log("opened a connection") }

              ws.onmessage { |msg|
                begin
                  since_time =  Time.at(msg.to_i)
                  changes = change_set_class.new(since: since_time)
                  if changes.any?
                    React::Rails::HotLoader.log("received message: #{msg}")
                    React::Rails::HotLoader.log("sent response: #{changes.to_json}")
                    ws.send(changes.to_json)
                  end
                rescue StandardError => err
                  React::Rails::HotLoader.log("message error: #{err}\n #{err.backtrace.join("\n")}")
                end
              }

              ws.onclose { React::Rails::HotLoader.log("closed a connection") }
            end

            React::Rails::HotLoader.log("started WS server")
          }
        end
      end
    end
  end
end

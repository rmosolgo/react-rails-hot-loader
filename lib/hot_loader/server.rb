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
        end

        # Restarts the server _if_ it has stopped
        def restart
          start
        rescue StandardError => err
          if err.message =~ /no acceptor/
            React::Rails::HotLoader.log("WS server is already running (#{ws_url})")
          else
            React::Rails::HotLoader.error(err)
          end
        end

        private

        # If the Rails server runs event machine already,
        # don't run EventMachine again, instead hook in with `next_tick`
        def start
          if already_has_event_machine_server?
            EM.next_tick { run_websocket_server }
          else
            Thread.new do
              EM.run { run_websocket_server }
            end
          end
        end

        # Check for any changes since `msg`, respond if there are any changes
        def handle_message(ws, msg)
          # React::Rails::HotLoader.log("received message: #{msg}")
          since_time =  Time.at(msg.to_i)
          changes = change_set_class.new(since: since_time)
          if changes.bankrupt?
            changed_files_count = changes.changed_file_names.length
            React::Rails::HotLoader.log("declared bankruptcy! (#{changed_files_count} files changed)")

            bankruptcy_response = {
              bankrupt: true,
              changed_files: changed_files_count,
            }

            ws.send(bankruptcy_response.to_json)
          elsif changes.any?
            React::Rails::HotLoader.log("sent changes: #{changes.changed_file_names}")
            ws.send(changes.to_json)
          end
        rescue StandardError => err
          React::Rails::HotLoader.error(err)
        end

        def run_websocket_server
          ws_url =  "ws://#{host}:#{port}"
          React::Rails::HotLoader.log("starting WS server (#{ws_url})")

          EM::WebSocket.run(host: host, port: port) do |ws|
            ws.onopen     { React::Rails::HotLoader.log("opened a connection (#{ws_url})") }
            ws.onmessage  { |msg| handle_message(ws, msg) }
            ws.onclose    { React::Rails::HotLoader.log("closed a connection (#{ws_url})") }
          end

          React::Rails::HotLoader.log("started WS server (#{ws_url})")

        end

        def already_has_event_machine_server?
          defined?(Thin)
        end
      end
    end
  end
end

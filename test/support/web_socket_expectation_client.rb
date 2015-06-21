require 'websocket-client-simple'
# records responses for testing the WS Server

class WebSocketExpectationClient
  attr_reader :received, :ws
  def initialize(url)
    @received = []
    client = self

    begin
      @ws = WebSocket::Client::Simple.connect(url)
      ws.on :open do
        client.log "ExpectationClient open"
      end

      ws.on :close do
        client.log "ExpectationClient closed"
      end

      ws.on :message do |msg|
        client.log "ExpectationClient received: #{msg.data}"
        client.received << msg.data
      end
      ws.on :error do |err|
        client.log "ExpectationClient error: #{err}"
      end

      log "Started ExpectationClient"
    rescue StandardError => err
      log "Couldn't start ExpectationClient: #{err}"
    end

    # wait for connection to be ready:
    until ws.open?; end
  end

  def send(message)
    ws.send(message)
    log "ExpectationClient: sent #{message}"
  end

  def log(message)
    # puts message
  end
end

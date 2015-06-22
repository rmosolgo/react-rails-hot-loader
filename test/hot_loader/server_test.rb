require 'test_helper'

describe React::Rails::HotLoader::Server do
  before do
    @server = React::Rails::HotLoader::Server.new(port: 7070)
    @server.restart
    @client = WebSocketExpectationClient.new("ws://localhost:7070")
  end

  it 'sends asset paths which have changed since that time' do
    asset_path = Rails.root.join("app/assets/javascripts/test_asset_1.js.jsx")
    FileUtils.touch(asset_path)
    @client.send((Time.now.to_i - 60).to_s)

    # wait for response:
    until @client.received.length > 0; end

    assert_equal 1, @client.received.length
    changed_contents = JSON.parse(@client.received.last)["changed_asset_contents"]
    expected_content = File.read(asset_path)
    assert_equal [expected_content], changed_contents
  end
end

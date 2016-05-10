require 'test_helper'

describe React::Rails::HotLoader::Server do
  before do
    @server = React::Rails::HotLoader::Server.new(port: 7070)
    @server.restart
    @client = WebSocketExpectationClient.new("ws://localhost:7070")
  end

  it 'sends asset paths which have changed since that time' do
    touch_asset("test_asset_1.js.jsx")
    @client.send(Time.now.to_i.to_s)

    # wait for response:
    until @client.received.length > 0; end

    assert_equal 1, @client.received.length
    changed_contents = JSON.parse(@client.received.last)["changed_asset_contents"]
    expected_content = Rails.application.assets["test_asset_1.js"].to_s
    assert_equal [expected_content], changed_contents
  end

  describe "when too many files changed" do
    before do
      React::Rails::HotLoader::AssetChangeSet.bankruptcy_count = 2
    end

    after do
      React::Rails::HotLoader::AssetChangeSet.bankruptcy_count = 10
    end

    it "sends a bankruptcy response" do
      touch_asset("test_asset_1.js.jsx")
      touch_asset("test_asset_2.js.jsx")
      touch_asset("test_asset_3.js.jsx")
      @client.send(Time.now.to_i.to_s)

      # wait for response:
      until @client.received.length > 0; end

      assert_equal 1, @client.received.length
      ws_response = JSON.parse(@client.received.last)
      assert_equal({"bankrupt" => true, "changed_files" => 3}, ws_response)
    end
  end
end

require 'test_helper'

describe React::Rails::HotLoader do
  describe '.start' do
    it 'passes args to Server and calls restart' do
      @server_mock = MiniTest::Mock.new
      @server_mock.expect(:restart, nil)
      @server_mock.expect(:new, @server_mock, [{option: "value"}])
      React::Rails::HotLoader.start(server_class: @server_mock, option: "value")
      @server_mock.verify
    end
  end
end

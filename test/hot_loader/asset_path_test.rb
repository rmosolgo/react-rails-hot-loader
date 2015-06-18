require 'test_helper'

describe React::Rails::HotLoader::AssetPath do
  before do
    @gem_asset_path = File.expand_path('../../../lib/assets', __FILE__)
  end

  it 'points to the real thing' do
    path = React::Rails::HotLoader::AssetPath.new
    real_path = @gem_asset_path
    assert_equal(real_path, path.to_s)
  end

  it 'points to a dummy if dummy: true' do
    path = React::Rails::HotLoader::AssetPath.new(dummy: true)
    dummy_path = @gem_asset_path + "/dummy"
    assert_equal(dummy_path, path.to_s)
  end
end

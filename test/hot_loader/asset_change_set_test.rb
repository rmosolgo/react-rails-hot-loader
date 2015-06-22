require 'test_helper'

TEST_ASSET_1 = "var testAsset1 = function() {\n  return \"test asset 1\"\n}\n"

describe React::Rails::HotLoader::AssetChangeSet do
  it 'notes files that changed' do
    since = Time.now
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert !change_set.any?, "At first, no files changed"
    sleep 1
    FileUtils.touch(Rails.root.join("app/assets/javascripts/test_asset_1.js.jsx"))
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert change_set.any?, "After a touch, one file is changed"
    assert_equal [TEST_ASSET_1], change_set.changed_asset_contents, "It prepares the asset for the browser"
  end
end

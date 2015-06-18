require 'test_helper'

describe React::Rails::HotLoader::AssetChangeSet do
  it 'notes files that changed' do
    since = Time.now
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert !change_set.any?, "At first, no files changed"
    sleep 1
    FileUtils.touch(Rails.root.join("app/assets/javascripts/test_asset_1.js.coffee"))
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert change_set.any?, "After a touch, one file is changed"
    assert_equal ["/assets/test_asset_1.js"], change_set.changed_asset_paths, "It prepares the path for the browser"
  end
end

require 'test_helper'

TEST_ASSET_1 = %|var testAsset1 = function () {
  return React.createElement(
    "span",
    null,
    "test asset 1"
  );
};
|

TEST_STYLES_1 = %|header h1 {
  color: red; }
|

describe React::Rails::HotLoader::AssetChangeSet do
  it 'notes javascripts that changed' do
    since = Time.now
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert !change_set.any?, "At first, no files changed"
    sleep 1
    touch_asset("test_asset_1.js.jsx")
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert change_set.any?, "After a touch, one file is changed"
    assert_equal [TEST_ASSET_1], change_set.changed_asset_contents, "It prepares the asset for the browser"
  end

  it 'notes stylesheets that changed' do
    since = Time.now
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert !change_set.any?, "At first, no files changed"

    sleep 1

    touch_asset("test_styles_1.css.scss")
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert change_set.any?, "After a touch, one file is changed"
    assert_equal ["test_styles_1.css.scss"], change_set.changed_file_names, "It uses the right file extension"
    assert_equal [TEST_STYLES_1], change_set.changed_asset_contents, "It prepares the asset for the browser"

    since = Time.now
    sleep 1

    touch_asset("test_styles_2.sass")
    change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
    assert change_set.any?, "After a touch, one file is changed"
    assert_equal [TEST_STYLES_1], change_set.changed_asset_contents, "It prepares the asset for the browser"
    assert_equal ["test_styles_2.sass"], change_set.changed_file_names, "It uses the right file extension"
  end

  describe "#bankrupt?" do
    describe "when more files changed than the bankruptcy_count" do
      before do
        React::Rails::HotLoader::AssetChangeSet.bankruptcy_count = 2
      end

      after do
        React::Rails::HotLoader::AssetChangeSet.bankruptcy_count = 10
      end

      it "is true" do
        since = Time.now
        sleep 1
        touch_asset("test_asset_1.js.jsx")
        touch_asset("test_asset_2.js.jsx")
        touch_asset("test_asset_3.js.jsx")
        change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
        assert change_set.bankrupt?, "More files changed than it can handle"
      end
    end

    describe "when fewer files changed than the bankruptcy_count" do
      it "is false" do
        since = Time.now
        sleep 1
        touch_asset("test_asset_1.js.jsx")
        change_set = React::Rails::HotLoader::AssetChangeSet.new(since: since)
        assert change_set.any?, "Some files changed"
        assert !change_set.bankrupt?, "But not too many files"
      end
    end
  end
end

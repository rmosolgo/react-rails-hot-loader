module React
  module Rails
    module HotLoader
      # We want to include different files in dev/prod. The production (dummy) file is empty!
      class AssetPath

        GEM_LIB_PATH = Pathname.new('../../').expand_path(__FILE__)

        attr_reader :to_s

        def initialize(dummy: false)
          asset_path = dummy ? "assets/dummy": "assets"
          @to_s = File.join(GEM_LIB_PATH, asset_path)
        end
      end
    end
  end
end

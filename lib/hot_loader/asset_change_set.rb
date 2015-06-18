module React
  module Rails
    module HotLoader
      class AssetChangeSet
        attr_reader :since, :path, :changed_files, :changed_asset_paths
        # initialize with a path and time
        # to find files which changed since that time
        def initialize(since:, path: ::Rails.root.join("app/assets/javascripts"))
          @since = since
          @path = path.to_s
          asset_glob = path.to_s + "/**/*.js.*"
          @changed_files = Dir.glob(asset_glob).select { |f| File.mtime(f) >= since }
          @changed_asset_paths = changed_files.map {|f| f.sub(path.to_s, "/assets").sub(/\.js.*/, ".js")}
        end

        def any?
          changed_asset_paths.any?
        end

        def as_json(options={})
          {
            since: since,
            path: path,
            changed_asset_paths: changed_asset_paths,
          }
        end
      end
    end
  end
end

module React
  module Rails
    module HotLoader
      class AssetChangeSet
        attr_reader :since, :path, :changed_files, :changed_file_names, :changed_asset_contents
        # initialize with a path and time
        # to find files which changed since that time
        def initialize(since:, path: ::Rails.root.join("app/assets/javascripts"))
          @since = since
          @path = path.to_s
          asset_glob = path.to_s + "/**/*.js*"
          @changed_files = Dir.glob(asset_glob).select { |f| File.mtime(f) >= since }
          @changed_file_names = changed_files.map { |f| f.split("/").last }
          @changed_asset_contents = changed_files.map do |f|
            logical_path = f.sub(path.to_s, "").sub(/^\//, '')
            ::Rails.application.assets[logical_path].to_s
          end
        end

        def any?
          changed_files.any?
        end

        def as_json(options={})
          {
            since: since,
            path: path,
            changed_file_names: changed_file_names,
            changed_asset_contents: changed_asset_contents,
          }
        end
      end
    end
  end
end

module React
  module Rails
    module HotLoader
      class AssetChangeSet
        attr_reader :since, :path, :changed_files, :changed_file_names, :changed_asset_contents
        class_attribute :asset_glob
        self.asset_glob = "/**/*.{js,coffee}*"

        # initialize with a path and time
        # to find files which changed since that time
        def initialize(since:, path: ::Rails.root.join("app/assets/javascripts"))
          @since = since
          @path = path.to_s
          asset_glob = File.join(path, AssetChangeSet.asset_glob)
          @changed_files = Dir.glob(asset_glob).select { |f| File.mtime(f) >= since }
          @changed_file_names = changed_files.map { |f| f.split("/").last }
          @changed_asset_contents = changed_files.map do |f|
            logical_path = to_logical_path(f)
            asset = ::Rails.application.assets[logical_path]
            asset.to_s
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

        private

        def to_logical_path(asset_path)
          asset_path
            .sub(@path, "")       # remove the basepath
            .sub(/^\//, '')       # remove any leading /
            .sub(/\.js.*/, '.js') # replace any file extension with `.js`
        end
      end
    end
  end
end

module React
  module Rails
    module HotLoader
      class AssetChangeSet
        attr_reader :since, :path, :changed_files, :changed_file_names
        class_attribute :asset_glob, :bankruptcy_count
        # Search for changes with this glob
        self.asset_glob = "/**/*.{css,js,coffee}*"
        # If this many files change at once, give up hope! (Probably checked out a new branch)
        self.bankruptcy_count = 5

        # initialize with a path and time
        # to find files which changed since that time
        def initialize(since:, path: ::Rails.root.join("app/assets"))
          @since = since
          @path = path.to_s
          asset_glob = File.join(path, AssetChangeSet.asset_glob)
          @changed_files = Dir.glob(asset_glob).select { |f| File.mtime(f) >= since }
          @changed_file_names = changed_files.map { |f| File.basename(f) }
        end

        def bankrupt?
          changed_files.length >= self.class.bankruptcy_count
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

        def changed_asset_contents
          @changed_asset_contents ||= changed_files.map do |f|
            logical_path = to_logical_path(f)
            asset = ::Rails.application.assets[logical_path]
            asset.to_s
          end
        end

        private

        def to_logical_path(asset_path)
          asset_path
            .sub(@path, "")                     # remove the basepath
            .sub(/(javascripts|stylesheets)\//, '') # remove the asset directory
            .sub(/^\//, '')                     # remove any leading /
            .sub(/(\.js|\.css).*/, '\1') # replace any file extension with `.js` or `.css`
        end
      end
    end
  end
end

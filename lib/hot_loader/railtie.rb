module React
  module Rails
    module HotLoader
      class Railtie < ::Rails::Railtie
        config.before_initialize do |app|
          # We want to include different files in dev/prod. The production file is empty!
          asset_path = React::Rails::HotLoader::AssetPath.new(dummy: !(::Rails.env.development?))
          app.config.assets.paths << asset_path.to_s
        end

        config.after_initialize do |app|
          ActionDispatch::Reloader.to_prepare do
            begin
              React::Rails::HotLoader.restart
            rescue StandardError => err
              React::Rails::HotLoader.error(err)
            end
          end
        end
      end
    end
  end
end

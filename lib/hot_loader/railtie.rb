module React
  module Rails
    module HotLoader
      class Railtie < ::Rails::Railtie
        config.before_initialize do |app|
          asset_path = React::Rails::HotLoader::AssetPath.new(dummy: !(::Rails.env.development?))
          app.config.assets.paths << asset_path.to_s
        end

        config.after_initialize do |app|
          ActionDispatch::Reloader.to_prepare do
            # Seems like Passenger kills threads on the main process
            # In that case, `starting_worker_process` isn't good enough
            # because it doesn't run :(
            React::Rails::HotLoader.restart
          end

          if defined?(PhusionPassenger)
            PhusionPassenger.on_event(:starting_worker_process) do |forked|
              if forked
                # We're in smart spawning mode.
                React::Rails::HotLoader.restart
              else
                # We're in direct spawning mode. We don't need to do anything.
              end
            end
          end
        end
      end
    end
  end
end

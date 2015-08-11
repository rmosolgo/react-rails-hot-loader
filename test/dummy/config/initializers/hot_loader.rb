if ::Rails.env.development?
  React::Rails::HotLoader.start(port: 8083)
end

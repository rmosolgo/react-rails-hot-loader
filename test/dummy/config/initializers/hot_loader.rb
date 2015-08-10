if ::Rails.env.development?
  React::Rails::HotLoader.start
end

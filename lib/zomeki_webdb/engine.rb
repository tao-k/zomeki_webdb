module ZomekiWebdb
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path("../../../lib", __FILE__)
    config.autoload_paths << File.expand_path("../../../app/jobs", __FILE__)
    config.after_initialize do |app|
      app.config.x.engines << self
    end
  end
end

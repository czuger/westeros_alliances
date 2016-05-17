module WesterosAlliances
  class Engine < ::Rails::Engine
    isolate_namespace WesterosAlliances

    config.generators do |g|
      g.fixture_replacement :factory_girl
    end

  end
end

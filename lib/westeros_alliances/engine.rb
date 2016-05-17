module WesterosAlliances
  class Engine < ::Rails::Engine
    isolate_namespace WesterosAlliances

    config.generators do |g|
      g.fixture_replacement :factory_girl
      g.test_framework :test_unit, fixture: true
    end

  end
end

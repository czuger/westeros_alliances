module WesterosAlliances
  class Engine < ::Rails::Engine
    isolate_namespace WesterosAlliances

    # Engines don't seem to load config/initializers with rails g, see : https://github.com/rails/rails/issues/14472
    # config.generators do |g|
    #   g.fixture_replacement :factory_girl
    #   g.test_framework :test_unit, fixture: true
    # end

  end
end

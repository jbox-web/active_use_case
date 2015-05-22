module ActiveUseCase
  class Engine < ::Rails::Engine

    isolate_namespace ActiveUseCase

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.integration_tool :rspec
      g.assets false
      g.helper false
    end

    initializer "include ActiveUseCase into ActiveRecord" do |app|
      ActiveRecord::Base.send(:include, ActiveUseCase::Model)
    end

  end
end

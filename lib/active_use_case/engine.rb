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

    initializer 'active_use_case.set_logger' do |app|
      ActiveUseCase.logger = Rails.logger
    end

  end
end

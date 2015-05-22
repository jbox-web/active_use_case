require 'active_use_case/engine'
require 'active_use_case/base'
require 'active_use_case/errors'
require 'active_use_case/use_case'
require 'active_use_case/version'

module ActiveUseCase
  autoload :Model,         'active_use_case/model'
  autoload :ModelBehavior, 'active_use_case/model_behavior'

  class << self

    def logger=(logger)
      @logger ||= logger
    end

    def logger
      @logger || Rails.logger
    end

  end
end

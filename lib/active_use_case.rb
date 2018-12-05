# frozen_string_literal: true

require 'active_use_case/engine'
require 'active_use_case/base'
require 'active_use_case/errors'
require 'active_use_case/model'
require 'active_use_case/use_case_builder'
require 'active_use_case/version'

module ActiveUseCase
  mattr_accessor :logger
end

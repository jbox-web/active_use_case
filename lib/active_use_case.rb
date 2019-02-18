# frozen_string_literal: true

require 'zeitwerk'
Zeitwerk::Loader.for_gem.setup

module ActiveUseCase
  mattr_accessor :logger
end

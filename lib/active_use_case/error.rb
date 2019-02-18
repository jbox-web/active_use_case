# frozen_string_literal: true

module ActiveUseCase
  module Error
    class ActiveUseCaseError < StandardError; end
    class UseCaseNotDefinedError < ActiveUseCaseError; end
    class UseCaseClassNotFoundError < ActiveUseCaseError; end
  end
end

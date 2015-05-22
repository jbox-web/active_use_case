module ActiveUseCase
  module Errors
    class ActiveUseCaseError < StandardError; end
    class UseCaseNotDefinedError < ActiveUseCaseError; end
    class UseCaseClassNotFoundError < ActiveUseCaseError; end
  end
end

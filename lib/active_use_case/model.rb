module ActiveUseCase
  module Model
    extend ActiveSupport::Concern
    include ActiveUseCase::ModelBehavior
  end
end

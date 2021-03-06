# frozen_string_literal: true

module ActiveUseCase
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :active_use_cases
      self.active_use_cases = {}

      class << self

        def add_use_cases(use_cases = [], opts = {})
          namespace = opts.delete(:namespace) { name.pluralize }
          prefix    = opts.delete(:prefix) { nil }

          use_cases.each do |use_case|
            add_use_case(use_case, namespace, prefix)
          end
        end


        def find_active_use_case(method)
          method = method.to_s
          method = "#{method}!" unless method.end_with?('!')
          method = method.to_sym

          raise ActiveUseCase::Error::UseCaseNotDefinedError unless active_use_cases[method]

          use_case = active_use_cases[method]
          raise(ActiveUseCase::Error::UseCaseClassNotFoundError) unless use_case.exists?

          use_case
        end


        private


          def add_use_case(use_case, namespace, prefix)
            build_method = "build_#{use_case}_use_case".to_sym
            exec_method  = "#{use_case}!".to_sym
            active_use_cases[exec_method] = UseCaseBuilder.new(exec_method, namespace, prefix)

            define_method build_method do
              UseCaseBuilder.new(exec_method, namespace, prefix)
            end

            define_method exec_method do |*args, &block|
              use_case = send(build_method).to_object(self)
              use_case.call(*args, &block)
            end
          end

      end
    end


    # rubocop:disable Style/RescueStandardError, Style/RedundantBegin
    def find_active_use_case(method)
      begin
        use_case = self.class.find_active_use_case(method)
      rescue => e
        raise e
      else
        use_case.to_object(self)
      end
    end
    # rubocop:enable Style/RescueStandardError, Style/RedundantBegin

  end
end

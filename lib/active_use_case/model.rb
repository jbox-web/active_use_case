module ActiveUseCase
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :active_use_cases

      class << self

        def add_use_cases(use_cases = [], opts = {})
          self.active_use_cases = {} if self.active_use_cases.nil?
          parent_klass = opts.delete(:parent_klass){ nil }
          prefix       = opts.delete(:prefix){ nil }

          use_cases.each do |use_case|
            add_use_case(use_case, parent_klass, prefix)
          end
        end


        def find_active_use_case(method)
          method = "#{method}"
          method = "#{method}!" if !method.end_with?('!')
          method = method.to_sym
          if active_use_cases[method]
            use_case = active_use_cases[method]
            use_case.exists? ? use_case : raise(ActiveUseCase::Errors::UseCaseClassNotFoundError)
          else
            raise ActiveUseCase::Errors::UseCaseNotDefinedError
          end
        end


        private


          def add_use_case(use_case, parent_klass, prefix)
            build_method = "build_#{use_case}_use_case".to_sym
            exec_method  = "#{use_case}!".to_sym
            self.active_use_cases[exec_method] = UseCaseBuilder.new(exec_method, parent_klass, prefix)

            define_method build_method do
              UseCaseBuilder.new(exec_method, parent_klass, prefix)
            end

            define_method exec_method do |*args, &block|
              use_case = send("#{build_method}").to_object(self)
              use_case.call(*args, &block)
            end
          end

      end
    end


    def find_active_use_case(method)
      begin
        use_case = self.class.find_active_use_case(method)
      rescue => e
        raise e
      else
        use_case.to_object(self)
      end
    end

  end
end

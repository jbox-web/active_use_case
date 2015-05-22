module ActiveUseCase
  module ModelBehavior
    extend ActiveSupport::Concern

    included do
      class_attribute :active_use_cases
    end


    module ClassMethods

      def add_use_cases(use_cases = [], opts = {})
        self.active_use_cases = {} if self.active_use_cases.nil?
        parent_klass = self.base_class.name.pluralize
        prefix = opts.delete(:prefix){ '' }
        use_cases.each do |use_case|
          case_name = "#{use_case}!".to_sym
          self.active_use_cases[case_name] = UseCase.new(case_name, parent_klass, prefix)
        end
      end


      def find_active_use_case(method)
        method = "#{method}!" if !method.end_with?('!')
        method = method.to_sym
        if active_use_cases.keys.include?(method)
          active_use_cases[method]
        else
          raise UseCaseNotDefinedError
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


    def method_missing(method, *args, &block)
      if self.class.active_use_cases.keys.include?(method)
        use_case = self.class.active_use_cases[method].to_object(self)
        use_case.call(*args, &block)
      else
        super
      end
    end

  end
end

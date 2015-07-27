module ActiveUseCase
  class Base

    attr_reader :object
    attr_reader :use_case


    def initialize(object)
      @object       = object
      @object_klass = object.class.base_class.name
      @object_type  = @object_klass.underscore
      @use_case     = self.class.name.split('::').last.underscore
      @errors       = []

      # Add method helper
      define_singleton_method(@object_type) { object }
    end


    def call(*args, &block)
      execute(*args, &block)
      return self
    end


    def to_method
      use_case + '!'
    end


    def success?
      errors.empty?
    end


    def errors
      @errors.uniq
    end


    def message_on_start
      I18n.t("use_cases.#{@object_type}.#{use_case}.start", @object_type.to_sym => object.to_s)
    end


    def message_on_success
      I18n.t("use_cases.#{@object_type}.#{use_case}.success", @object_type.to_sym => object.to_s)
    end


    def message_on_errors
      I18n.t("use_cases.#{@object_type}.#{use_case}.failed", @object_type.to_sym => object.to_s, errors: errors.to_sentence)
    end


    private


      def error_message(message)
        @errors << message
      end


      def log_message(message)
        use_case_logger.info message
      end


      def log_exception(e)
        use_case_logger.error e.message
      end


      def use_case_logger
        ActiveUseCase.logger
      end

  end
end

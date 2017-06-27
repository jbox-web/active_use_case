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


    def execute(*, &block)
      raise NotImplementedError
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
      tt('start')
    end


    def message_on_success
      tt('success')
    end


    def message_on_errors
      tt('failed', errors: errors.to_sentence)
    end


    def message_on_nil_object
      tt('errors.nil_object')
    end


    private


      def tt(str, opts = {})
        t(str, opts.merge(@object_type.to_sym => object.to_s))
      end


      def t(str, opts = {})
        I18n.t("#{i18n_prefix}.#{str}", opts)
      end


      def i18n_prefix
        "use_cases.#{@object_type}.#{use_case}"
      end


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

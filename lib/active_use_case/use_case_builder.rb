# frozen_string_literal: true

module ActiveUseCase
  class UseCaseBuilder

    attr_reader :method
    attr_reader :namespace
    attr_reader :prefix


    def initialize(method, namespace = nil, prefix = nil)
      @method    = method
      @namespace = namespace
      @prefix    = prefix
    end


    def name
      @name ||= method.to_s.delete('!')
    end


    def klass_name
      @klass_name ||= name.camelize
    end


    def klass_path
      @klass_path ||= [namespace, prefix, klass_name].compact.join('::')
    end


    def klass
      @klass ||= klass_path.safe_constantize
    end


    def exists?
      !klass.nil?
    end


    def to_object(object)
      raise ActiveUseCase::Errors::UseCaseClassNotFoundError, klass_path unless exists?

      klass.new(object)
    end

  end
end

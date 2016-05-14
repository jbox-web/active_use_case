module ActiveUseCase
  class UseCaseBuilder

    attr_reader :method
    attr_reader :parent_klass
    attr_reader :prefix


    def initialize(method, parent_klass = nil, prefix = nil)
      @method       = method
      @parent_klass = parent_klass
      @prefix       = prefix
    end


    def name
      @name ||= method.to_s.gsub('!', '')
    end


    def klass_name
      @klass_name ||= name.camelize
    end


    def klass_path
      @klass_path ||= [parent_klass, prefix, klass_name].compact.join('::')
    end


    def klass
      @klass ||= klass_path.safe_constantize
    end


    def exists?
      !klass.nil?
    end


    def to_object(object)
      raise ActiveUseCase::Errors::UseCaseClassNotFoundError, klass_path if !exists?
      klass.new(object)
    end

  end
end

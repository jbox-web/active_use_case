module ActiveUseCase
  class UseCase

    attr_reader :method
    attr_reader :name
    attr_reader :parent_klass
    attr_reader :prefix
    attr_reader :klass_name
    attr_reader :klass_path


    def initialize(name, parent_klass, prefix)
      @method       = name
      @name         = name.to_s.gsub('!', '')
      @parent_klass = parent_klass
      @prefix       = prefix
      @klass_name   = @name.camelize
      @klass_path   = "#{@parent_klass}#{@prefix}::#{@klass_name}"
    end


    def to_object(object)
      begin
        klass = klass_path.constantize
      rescue NameError => e
        raise ActiveUseCase::UseCaseClassNotFoundError, e
      else
        klass.new(object)
      end
    end

  end
end

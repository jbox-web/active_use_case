module Comments
  class SendEmail  < ActiveUseCase::Base
    def execute(email, &block)
      yield email if block_given?
    end
  end
end

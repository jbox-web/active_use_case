class Comment < ApplicationRecord
  include ActiveUseCase::Model
  add_use_cases [:send_email, :send_sms]
  add_use_cases [:generate_pdf, :resync], prefix: 'Files'
end

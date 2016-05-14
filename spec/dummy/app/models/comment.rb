class Comment < ApplicationRecord
  add_use_cases [:send_email, :send_sms], namespace: self.name.pluralize
  add_use_cases [:generate_pdf, :resync], namespace: self.name.pluralize, prefix: 'Files'
end

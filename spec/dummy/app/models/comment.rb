class Comment < ApplicationRecord
  add_use_cases [:send_email, :send_sms], parent_klass: self.name.pluralize
  add_use_cases [:generate_pdf, :resync], parent_klass: self.name.pluralize, prefix: 'Files'
end

class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.text    :content
      t.timestamps
    end
  end
end

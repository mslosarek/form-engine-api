class AddUserToForms < ActiveRecord::Migration[7.1]
  def change
    add_reference :forms, :user, type: :uuid, null: false, foreign_key: true
  end
end

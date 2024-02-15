class CreateForms < ActiveRecord::Migration[7.1]
  def change
    create_table :forms, id: :uuid do |t|
      t.string :name
      t.string :title
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end

class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.string :company
      t.string :locale, null: false, default: "da"

      t.timestamps
    end
  end
end

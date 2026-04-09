class CreateSectionProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :section_progresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :section_progresses, %i[customer_id section_id], unique: true
  end
end

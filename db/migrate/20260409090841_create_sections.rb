class CreateSections < ActiveRecord::Migration[8.1]
  def change
    create_table :sections do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :position, null: false

      t.timestamps
    end

    add_index :sections, %i[course_id position], unique: true
    add_index :sections, %i[course_id slug], unique: true
  end
end

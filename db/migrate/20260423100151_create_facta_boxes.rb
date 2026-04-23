class CreateFactaBoxes < ActiveRecord::Migration[8.1]
  def change
    create_table :facta_boxes do |t|
      t.references :section, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.integer :position, null: false

      t.timestamps
    end

    add_index :facta_boxes, [ :section_id, :position ]
  end
end

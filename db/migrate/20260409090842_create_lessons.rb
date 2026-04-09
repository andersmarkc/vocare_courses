class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :section, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.string :content_type, null: false
      t.text :body
      t.string :video_url
      t.integer :position, null: false
      t.integer :duration_seconds

      t.timestamps
    end

    add_index :lessons, %i[section_id position], unique: true
  end
end

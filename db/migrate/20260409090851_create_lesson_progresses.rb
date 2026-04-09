class CreateLessonProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :lesson_progresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at
      t.integer :last_position_seconds, null: false, default: 0

      t.timestamps
    end

    add_index :lesson_progresses, %i[customer_id lesson_id], unique: true
  end
end

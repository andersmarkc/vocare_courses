class CreateQuizAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_attempts do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.integer :score
      t.boolean :passed, null: false, default: false
      t.datetime :started_at, null: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :quiz_attempts, %i[quiz_id customer_id]
  end
end

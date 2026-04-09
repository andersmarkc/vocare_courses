class CreateQuizQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.text :question_text, null: false
      t.text :expected_answer, null: false
      t.integer :position, null: false
      t.integer :points, null: false, default: 1

      t.timestamps
    end
  end
end

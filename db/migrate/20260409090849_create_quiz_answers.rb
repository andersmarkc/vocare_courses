class CreateQuizAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_answers do |t|
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :quiz_question, null: false, foreign_key: true
      t.text :student_answer, null: false
      t.text :ai_evaluation
      t.integer :ai_score
      t.boolean :passed, null: false, default: false
      t.datetime :evaluated_at

      t.timestamps
    end

    add_index :quiz_answers, %i[quiz_attempt_id quiz_question_id], unique: true
  end
end

class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.references :quizzable, polymorphic: true, null: false
      t.string :title, null: false
      t.text :description
      t.integer :passing_score, null: false, default: 70

      t.timestamps
    end

    add_index :quizzes, %i[quizzable_type quizzable_id], unique: true
  end
end

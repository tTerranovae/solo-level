class CreateQuestionAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :question_attempts do |t|
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :user_answer
      t.boolean :is_correct
      t.integer :time_spent

      t.timestamps
    end
  end
end

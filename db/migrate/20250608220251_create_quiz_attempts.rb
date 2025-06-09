class CreateQuizAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.integer :score
      t.integer :total_questions
      t.datetime :completed_at

      t.timestamps
    end
  end
end

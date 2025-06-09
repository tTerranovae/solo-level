class AddQuestionMetadataToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :difficulty_level, :integer, default: 1, null: false
    add_column :questions, :question_type, :string, default: 'multiple_choice', null: false
    add_column :questions, :metadata, :jsonb, default: {}, null: false

    # Add indexes for better query performance
    add_index :questions, :difficulty_level
    add_index :questions, :question_type
    add_index :questions, :metadata, using: :gin

    # Add check constraint for difficulty_level
    execute <<-SQL
      ALTER TABLE questions
      ADD CONSTRAINT check_difficulty_level
      CHECK (difficulty_level BETWEEN 1 AND 5)
    SQL

    # Add check constraint for question_type
    execute <<-SQL
      ALTER TABLE questions
      ADD CONSTRAINT check_question_type
      CHECK (question_type IN ('multiple_choice', 'debugging', 'project_based'))
    SQL
  end
end

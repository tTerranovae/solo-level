class AddJsonOptionsToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :options, :jsonb
  end
end

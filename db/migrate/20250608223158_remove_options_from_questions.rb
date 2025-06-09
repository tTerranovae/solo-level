class RemoveOptionsFromQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :options, :text
  end
end

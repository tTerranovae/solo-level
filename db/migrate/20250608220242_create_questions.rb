class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.text :text
      t.string :qtype
      t.text :options
      t.string :correct_answer
      t.text :explanation
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end

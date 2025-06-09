class ChangeOptionsToArray < ActiveRecord::Migration[7.0]
  def change
    change_column :questions, :options, :text, array: true, default: [], using: "string_to_array(options, ',')"
  end
end

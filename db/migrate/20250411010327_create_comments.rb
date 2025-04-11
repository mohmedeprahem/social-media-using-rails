class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :author, null: false, foreign_key: { on_delete: :cascade, to_table: :users }
      t.references :post, null: false, foreign_key: { on_delete: :cascade, to_table: :posts }

      t.timestamps
    end
  end
end

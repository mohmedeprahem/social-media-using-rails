class AddCascadeDeleteToPostTags < ActiveRecord::Migration[8.0]
  def up
    # Remove existing foreign keys
    remove_foreign_key :post_tags, :posts
    remove_foreign_key :post_tags, :tags

    # Add new foreign keys with cascade delete
    add_foreign_key :post_tags, :posts, on_delete: :cascade
    add_foreign_key :post_tags, :tags, on_delete: :cascade
  end

  def down
    # For rollback - remove cascade foreign keys
    remove_foreign_key :post_tags, :posts
    remove_foreign_key :post_tags, :tags

    # Recreate original foreign keys without cascade
    add_foreign_key :post_tags, :posts
    add_foreign_key :post_tags, :tags
  end
end

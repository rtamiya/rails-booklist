class AddColumnToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :googlebooks_id, :string
    add_column :books, :googlebooks_link, :string
    add_column :books, :published_date, :string
    add_column :books, :page_count, :integer
    add_column :books, :categories, :string
    add_column :books, :image_link, :string
    add_column :books, :language, :string
    add_column :books, :subtitle, :string
  end
end

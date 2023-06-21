class RemovePublishedYearFromBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :books, :published_year
  end
end

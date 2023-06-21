class RemoveDiscriptionFromBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :books, :discription
  end
end

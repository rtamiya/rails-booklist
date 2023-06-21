class RenameDiscriptionToDescription < ActiveRecord::Migration[7.0]
  def change
    rename_column :lists, :discription, :description
  end
end

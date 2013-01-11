class AddManagerToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :manager, :boolean, default: false
  end
end

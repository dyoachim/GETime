class AddIndexToEmployeesUsername < ActiveRecord::Migration
  def change
  	add_index :employees, :username, unique: true
  end
end

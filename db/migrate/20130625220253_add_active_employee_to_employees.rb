class AddActiveEmployeeToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :active_employee, :boolean, default: true
  end
end

class AddEmployeeTimeZoneToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :employee_time_zone, :string, default: "UTC"
  end
end

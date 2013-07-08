class AddEmployeeTimeZoneToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :employee_time_zone, :string, default: "(GMT+00:00) UTC"
  end
end

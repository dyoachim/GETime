class RemoveChangeLogFromTimesheets < ActiveRecord::Migration
  def up
    remove_column :timesheets, :change_log
  end

  def down
    add_column :timesheets, :change_log, :string
  end
end

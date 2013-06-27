class DropTableChangeLogs < ActiveRecord::Migration
  def up
  	drop_table :change_logs
  end

  def down
  end
end

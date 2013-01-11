class CreateTimesheets < ActiveRecord::Migration
	def change
    	create_table :timesheets do |t|
      		t.column :punch_in, :DateTime
      		t.column :punch_out, :DateTime
      		t.integer :employee_id

	     	t.timestamps
    	end
    	add_index :timesheets, [:employee_id, :created_at]
	end
end

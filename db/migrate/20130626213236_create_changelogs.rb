class CreateChangelogs < ActiveRecord::Migration
  def change
    create_table :changelogs do |t|
      t.integer :timesheet_id
      t.string :changed_by
      t.column :old_in, :DateTime
      t.column :new_in, :DateTime
      t.column :old_out, :DateTime
      t.column :new_out, :DateTime

      t.timestamps
    end
    add_index :changelogs, [:timesheet_id, :created_at]
  end
end

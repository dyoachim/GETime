class Changelog < ActiveRecord::Base
  attr_accessible :changed_by, :new_in, :new_out, :old_in, :old_out
  belongs_to :timesheet

  validates :timesheet_id, presence: true
  validates :old_in, presence: true
  validates :old_out, presence: true
  validates :new_in, presence: true
  validates :new_out, presence: true
  validates :changed_by, presence: true
end

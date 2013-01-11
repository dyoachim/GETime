class Timesheet < ActiveRecord::Base
  attr_accessible :punch_in, :punch_out
  belongs_to :employee

  validates :punch_in, presence: true
  validates :employee_id, presence: true

  default_scope order: 'timesheets.created_at DESC'
end

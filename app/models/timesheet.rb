require 'json/ext'

class Timesheet < ActiveRecord::Base
  attr_accessible :punch_in, :punch_out, :change_log
  belongs_to :employee
  serialize :change_log

  validates :punch_in, presence: true
  validates :employee_id, presence: true

  default_scope order: 'timesheets.created_at DESC'

  def time_change(current_employee, update_to_punch_in, update_to_punch_out)
    if current_employee.manager?
      self.punch_in = update_to_punch_in
      self.punch_out = update_to_punch_out
      change_log_hash = {"In: #{punch_in}, Out: #{punch_out}" => current_employee.name}


      if change_log.nil?
        self.change_log = change_log_hash
      else
        self.change_log = change_log.merge(change_log_hash)
      end
      self.save!
    else
      false
    end
  end
end

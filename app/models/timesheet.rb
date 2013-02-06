require 'json/ext'

class Timesheet < ActiveRecord::Base
  attr_accessible :punch_in, :punch_out, :change_log
  belongs_to :employee

  validates :punch_in, presence: true
  validates :employee_id, presence: true

  default_scope order: 'timesheets.created_at DESC'

  def punch_in_management(current_employee, update_to_punch_in)
    if current_employee.manager?
      self.punch_in = update_to_punch_in
      change_log_hash = {"In: #{update_to_punch_in}" => current_employee.name}
      if change_log.nil?
        self.change_log = change_log_hash.as_json()
      else
        change_log.merge!(change_log_hash) { |key, v1, v2| v1 }
        self.change_log = change_log.as_json()
      end
    else
      return
    end
  end

  def punch_out_management(current_employee, update_to_punch_out)
  	if current_employee.manager?
  		self.punch_out = update_to_punch_out
  		change_log_hash = {"Out: #{update_to_punch_out}" => current_employee.name}
      if change_log.nil?
        self.change_log = change_log_hash.as_json()
      else
        change_log.merge!(change_log_hash) { |key, v1, v2| v1 }
        self.change_log = change_log.as_json()
      end
  	else
      return
    end
  end
end

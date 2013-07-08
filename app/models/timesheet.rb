require 'json/ext'

class Timesheet < ActiveRecord::Base
  attr_accessible :punch_in, :punch_out
  belongs_to :employee
  has_many :changelogs
  
  serialize :change_log

  validates :punch_in, presence: true
  validates :employee_id, presence: true

  default_scope order: 'timesheets.created_at DESC'

  def manager_time_correction(current_employee, update_to_punch_in, update_to_punch_out)
    if current_employee.manager?
      old_in = self.punch_in
      old_out = self.punch_out
      
      self.punch_in = update_to_punch_in
      self.punch_out = update_to_punch_out
      self.save!
      self.make_log(current_employee, old_in, old_out ,update_to_punch_in, update_to_punch_out)
    else
      false
    end
  end

  def make_log(current_employee, old_in, old_out, new_in, new_out)
      self.changelogs.build(:changed_by => current_employee.name, :old_in => old_in, :old_out => old_out, :new_in => new_in, :new_out => new_out)
      self.save!
  end

  def hours_worked
    if (punch_in == nil || punch_out == nil || (punch_out < punch_in))
      return nil
    else
      elapsed_hours = ((punch_out - punch_in) / 3600).to_f.round(2)
      return elapsed_hours
    end
  end
end

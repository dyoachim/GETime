class TimesheetsController < ApplicationController
  before_filter :logged_in_employee

  def create
  	@timesheet = current_employee.timesheets.build(:punch_in => DateTime.now)
    if @timesheet.save
      flash[:success] = "Clocked in!"
      current_employee.toggle!(:clocked_in)
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  def update
  	if current_employee.timesheets.first.update_attributes(:punch_out => DateTime.now)
  		flash[:success] = "Clocked out!"
  		current_employee.toggle!(:clocked_in)
  		redirect_to root_url
  	else
  		redirect_to root_url
  	end
  end
end
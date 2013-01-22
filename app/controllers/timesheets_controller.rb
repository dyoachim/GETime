class TimesheetsController < ApplicationController
  before_filter :logged_in_employee

  def create
  	@timesheet = current_employee.timesheets.build(:punch_in => DateTime.now)
    if @timesheet.save
      current_employee.toggle!(:clocked_in)
      cookies[:remember_token] = current_employee.remember_token
    
    	flash[:success] = "Clocked in!"
    	redirect_to employees_path(:employee)
    else
      redirect_to root_url
    end
  end

  def update
  	if current_employee.timesheets.first.update_attributes(:punch_out => DateTime.now)
      current_employee.toggle!(:clocked_in)
      cookies[:remember_token] = current_employee.remember_token

  		flash[:success] = "Clocked out!"
  		redirect_to employees_path(:employee)
  	else
  		redirect_to root_url
  	end
  end
end
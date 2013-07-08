class TimesheetsController < ApplicationController
  before_filter :logged_in_employee

  def create
  	@timesheet = current_employee.timesheets.build(:punch_in => Time.now)
    if @timesheet.save
      current_employee.toggle!(:clocked_in)
      cookies[:remember_token] = current_employee.remember_token
    
    	flash[:success] = "Clocked in!"
    	redirect_to current_employee
    else
      redirect_to root_url
    end
  end

  def update
  	if current_employee.timesheets.first.update_attributes(:punch_out => Time.now)
      current_employee.toggle!(:clocked_in)
      cookies[:remember_token] = current_employee.remember_token

  		flash[:success] = "Clocked out!"
  		redirect_to current_employee
  	else
  		redirect_to root_url
  	end
  end

  def edit
    @employee = current_employee
    @timesheet = Timesheet.find(params[:id])
  end

  def time_change
    @timesheet = Timesheet.find(params[:id])
    if @timesheet.manager_time_correction(current_employee, params[:timesheet][:punch_in], params[:timesheet][:punch_out])
      flash[:success] = "Time changed successfully"
      redirect_to employee_path(@timesheet.employee_id)
    else
      flash[:failure] = "Failed to update"
      redirect_to root_url
    end
  end
end
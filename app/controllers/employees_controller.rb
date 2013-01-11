class EmployeesController < ApplicationController
  before_filter :logged_in_employee, only: [:index, :edit, :update, :destroy]
  before_filter :correct_employee,   only: [:edit, :update]
  before_filter :manager_employee,   only: :destroy
  
  def home
  end

  def show
    @employee = Employee.find(params[:id])
    @timesheets = @employee.timesheets.paginate(page: params[:page])
  end

  def new
  	@employee = Employee.new
  end

  def create
  	@employee = Employee.new(params[:employee])
  	if @employee.save
      log_in @employee
  		flash[:success] = "New employee successfully added"
  		redirect_to @employee
  	else
  		render 'new'
  	end
  end

  def destroy
    Employee.find(params[:id]).destroy
    flash[:success] = "Employee destroyed."
    redirect_to employees_url
  end

  def edit
  end

  def index
    @title = "All employees"
    @employees = Employee.paginate(page: params[:page])
  end

  def update
    if @employee.update_attributes(params[:employee])
      flash[:success] = "Account updated"
      log_in @employee
      redirect_to @employee
    else
      render 'edit'
    end
  end

  private
    def logged_in_employee
      unless logged_in?
        store_location
        redirect_to login_url, notice: "Please log in."
      end
    end

    def correct_employee
      @employee = Employee.find(params[:id])
      redirect_to(root_path) unless current_employee?(@employee)
    end

    def manager_employee
      redirect_to(root_path) unless current_employee.manager?
    end
end

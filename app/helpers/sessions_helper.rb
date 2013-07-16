module SessionsHelper

  def log_in(employee)
    cookies[:remember_token] = {value:   employee.remember_token, expires: 5.minutes.from_now.utc}
    @current_employee = employee
  end

  def logged_in?
    !current_employee.nil?
  end

  def clocked_in?
    @current_employee.clocked_in
  end

  def current_employee=(employee)
  	@current_employee = employee
  end

  def current_employee
    @current_employee ||= Employee.find_by_remember_token(cookies[:remember_token])
  end

  def current_employee?(employee)
    employee == current_employee
  end

  def logged_in_employee
    unless logged_in?
      store_location
      redirect_to login_url, notice: "Please log in."
    end
  end

  def log_out
    cookies.delete(:remember_token)
    @current_employee = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end

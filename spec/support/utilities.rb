def log_in(employee)
  visit login_path
  fill_in "Username",    with: employee.username
  fill_in "Password", with: employee.password
  click_button "Log in"
  cookies[:remember_token] = employee.remember_token
end
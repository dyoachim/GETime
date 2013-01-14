GEtiime README
by Daniel Yoachim

Overview
_____________________________________________
GEtime is an employee hours tracker. From the home page, create and account with login. When signed in, employees can update their name, username(which is used for the login), and password. 




To Create a new account
_____________________________________________
Create a new account from the add_worker path.
localhost:3000/add_worker


To Enable managaer status
_____________________________________________
Managers will be able to view all employees hour logs (Employees can only see their own). Managers can currently delete employees, which will remove all timesheets associated with them.

	Create the account you plan to change.
	rails console
	Employee.find_by_username(:username)
	Employee.toggle!.manager?


To Populate the database for testing purposes with FactoryGirl
_____________________________________________
	bundle exec rake db:migrate
	bundle exec rake db:populate
	bundle exec rake db:test:prepare


NOTES:

Failing Rspec tests on should_have input fields currently fail.
	1) EmployeesController GET 'new' should have a name field
	2) EmployeesController GET 'new' should have a username field
	3) EmployeesController GET 'new' should have a password field
	4) EmployeesController GET 'new' should have a password confirmation field

This is potentially due to an error in Rspec 2.x, and is being looked into.
http://www.rubyfocus.biz/blog/2011/01/08/from_have_tag_to_have_selector_in_rspec2_gotchas.html


Special Thanks to Mike Hartl's Ruby on Rails Tutorial. Much of the code borrows from his superb craftmanship and guidance.
http://ruby.railstutorial.org/

class SessionsController < ApplicationController

	def new
	end

	def create
		employee = Employee.find_by_username(params[:session][:username].downcase)
		if employee && employee.authenticate(params[:session][:password])
			log_in employee
			redirect_back_or employee
		else
	 	 flash.now[:error] = 'Invalid username/password combination'
	 	 render 'new'
		end
	end

	def destroy
		log_out
		redirect_to root_url
	end
end

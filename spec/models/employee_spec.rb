require 'spec_helper'

describe Employee do

  let(:employee) { FactoryGirl.create(:employee) }

  subject { employee }

  it { should respond_to(:name) }
  it { should respond_to(:username) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate)}
  it { should respond_to(:manager) }
  it { should respond_to(:timesheets) }


  it { should be_valid }
  it { should_not be_manager }

	context "when name is not present" do
		before { employee.name = " " }
		it { should_not be_valid }
	end

	context "when username is not present" do
		before { employee.username = " " }
		it { should_not be_valid }
	end

	context "when password is not present" do
		before { employee.password = employee.password_confirmation = " " }
		it { should_not be_valid }
	end

	context "when name is too long" do 
		before {employee.name = "a" * 41}
		it { should_not be_valid }
	end

	context "when password is too short" do
		before {employee.password = employee.password_confirmation = "a" * 5}
		it { should be_invalid }
	end

	context "when username is not unique" do
		before do
			@same_username = employee.dup
			@same_username.username = employee.username.upcase
			@same_username.save
		end
		it { @same_username.should_not be_valid }
	end


	context "when password confirmation is nil" do
		before { employee.password_confirmation = nil }
		it { should_not be_valid }
	end

	context "when password doesn't match password confirmation" do
		before { employee.password_confirmation = "incorrect" }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		let(:found_employee) { Employee.find_by_username(employee.username) }

		before { employee.save }
		
		context "with valid password" do
	    	it { should == found_employee.authenticate(employee.password) }
	  	end

	  	context "with invalid password" do
	    	let(:employee_for_invalid_password) { found_employee.authenticate("invalid") }

	    	it { should_not == employee_for_invalid_password }
	    	specify { employee_for_invalid_password.should be_false }
	  	end
	end

  	describe "remember token" do
    	before { employee.save }
    	its(:remember_token) { should_not be_blank }
    end

	context "with manager attribute set to 'true'" do
    	before do
      	employee.save!
      	employee.toggle!(:manager)
    	end

    	it { should be_manager }
  	end

  	context "destroy" do
  		it "sets active_employee to false" do
  			employee.destroy
  			employee.active_employee.should == false
  		end
  	end

  	describe "timesheets associations" do

    	before { employee.save }
    	let!(:older_timesheet) { FactoryGirl.create(:timesheet, employee: employee, punch_in: DateTime.yesterday, created_at: 1.day.ago) }
    	let!(:newer_timesheet) { FactoryGirl.create(:timesheet, employee: employee, punch_in: DateTime.now - 1.hour, created_at: 1.hour.ago) }

    	context "with the right microposts in the right order" do
      		it { employee.timesheets.should == [newer_timesheet, older_timesheet] }
    	end

    	it "should destroy associated timesheets" do
      		timesheets = employee.timesheets.dup
      		def employee.destroy
  				self.class.superclass.instance_method(:destroy).bind(self).call
			end
      		employee.destroy
      		timesheets.should_not be_empty
      		timesheets.each do |timesheet|
        		Timesheet.find_by_id(timesheet.id).should be_nil
      		end
    	end
  	end
end
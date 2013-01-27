require 'spec_helper'

describe Timesheet do

  let(:employee) { FactoryGirl.create(:employee) }
  let(:timesheet) { employee.timesheets.build(punch_in: DateTime.now, punch_out: DateTime.now + 1.hour) }

  subject { timesheet }

  it { should respond_to(:punch_in) }
  it { should respond_to(:punch_out) }
  it { should respond_to(:employee_id) }
  it { should respond_to(:employee) }
  its(:employee) { should == employee }

  it { should be_valid}

    context "when employee_id is not present" do
    	before { timesheet.employee_id = nil }
    	it { should_not be_valid }
  	end

  	describe "accessible attributes" do
    	it "does not allow access to employee_id" do
      		expect do
        		Timesheet.new(employee_id: employee.id)
      		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
   		end    
  	end
end
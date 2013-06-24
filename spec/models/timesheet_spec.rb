require 'spec_helper'

describe Timesheet do

  let(:employee) { FactoryGirl.create(:employee) }
  let(:manager) { FactoryGirl.create(:employee) }
  let(:timesheet) { employee.timesheets.build(punch_in: DateTime.now, punch_out: DateTime.now + 1.hour) }

  subject { timesheet }

  it { should respond_to(:punch_in) }
  it { should respond_to(:punch_out) }
  it { should respond_to(:employee_id) }
  it { should respond_to(:employee) }
  it { should respond_to(:change_log)}
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

  describe "manager powers" do
    update_to_punch_in = DateTime.now.utc - 1.hour   
    update_to_punch_out = DateTime.now.utc + 2.hours
    second_update_to_punch_in = DateTime.now.utc - 2.hours 
    second_update_to_punch_out = DateTime.now.utc + 3.hours

    context "manager" do
      before { manager.manager = true }

      context "first update" do
        before(:each) { timesheet.time_change(manager, update_to_punch_in, update_to_punch_out) }

        it "does update punch_in/out for selected employee" do
          timesheet.punch_in.should  == update_to_punch_in.to_datetime
          timesheet.punch_out.should == update_to_punch_out.to_datetime
        end

        it "does update change_log" do
          timesheet.change_log.should == {"In: #{update_to_punch_in.strftime("%-I:%M%P, %b %d %Y")}, Out: #{update_to_punch_out.strftime("%-I:%M%P, %b %d %Y")}" => manager.name}
        end
      end

      context "second update" do
        before(:each) { timesheet.time_change(manager, second_update_to_punch_in, second_update_to_punch_out) }

        it "does update punch_in again for selected employee" do
          timesheet.punch_in.should  == second_update_to_punch_in.to_datetime
          timesheet.punch_out.should == second_update_to_punch_out.to_datetime
        end

        it "does update change_log again" do
          timesheet.change_log.should == {"In: #{second_update_to_punch_in.strftime("%-I:%M%P, %b %d %Y")}, Out: #{second_update_to_punch_out.strftime("%-I:%M%P, %b %d %Y")}" => manager.name}
        end
      end
    end

    context "non-manager" do
      before { manager.manager = false }

      context "punch in" do
        before(:each) { timesheet.time_change(manager, update_to_punch_in, update_to_punch_out) }

        it "does not update punch_in/out for selected employee" do
          timesheet.punch_in.should_not  == update_to_punch_in.to_datetime
          timesheet.punch_out.should_not == update_to_punch_out.to_datetime
        end

        it "does not update change log" do
          timesheet.change_log.should == nil
        end
      end
    end
  end
end
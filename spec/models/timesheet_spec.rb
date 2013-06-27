require 'spec_helper'

describe Timesheet do

  let(:employee) { FactoryGirl.create(:employee) }
  let(:manager) { FactoryGirl.create(:manager) }
  let(:timesheet) { employee.timesheets.build(punch_in: Time.now, punch_out: Time.now + 1.hour) }

  subject { timesheet }

  it { should respond_to(:punch_in) }
  it { should respond_to(:punch_out) }
  it { should respond_to(:employee_id) }
  it { should respond_to(:employee) }
  it { should respond_to(:changelogs) }
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

  describe "hours_worked" do
    it "is nil when punch_out is missing" do
      timesheet.punch_out = nil
      timesheet.hours_worked.should == nil
    end

    it "is nil when punch_out is earlier than punch_in" do
      timesheet.punch_out = Time.now - 5.hours
      timesheet.hours_worked.should == nil
    end

    it "does display hours when punch_in and punch_out present" do
      timesheet.hours_worked.should == ((timesheet.punch_out - timesheet.punch_in) / 3600).to_f.round(2)
    end
  end

  describe "manager powers" do
    update_to_punch_in = Time.now.utc - 1.hour   
    update_to_punch_out = Time.now.utc + 2.hours

    context "manager" do
      
      before(:each) do
        @old_in = timesheet.punch_in
        @old_out = timesheet.punch_out
        timesheet.manager_time_correction(manager, update_to_punch_in, update_to_punch_out) 
      end

      it "does update punch_in/out for selected employee" do
        timesheet.punch_in.should  == update_to_punch_in
        timesheet.punch_out.should == update_to_punch_out
      end

      context "change log" do
        it "does create a log" do
          timesheet.changelogs.first.should_not == nil
        end

        it "has the right new_in" do
          timesheet.changelogs.first.new_in.should == update_to_punch_in
        end

        it "has the correct new_out" do
          timesheet.changelogs.first.new_out.should == update_to_punch_out
        end

        it "has the correct old_in" do
          timesheet.changelogs.first.old_in.should == @old_in
        end

        it "has the correct old_out" do
          timesheet.changelogs.first.old_out.should == @old_out
        end

        it "has the correct manager" do
          timesheet.changelogs.first.changed_by.should == manager.name
        end
      end    
    end

    context "non-manager" do
      before { manager.manager = false }

      context "punch in" do
        before(:each) { timesheet.manager_time_correction(manager, update_to_punch_in, update_to_punch_out) }

        it "does not update punch_in/out for selected employee" do
          timesheet.punch_in.should_not  == update_to_punch_in
          timesheet.punch_out.should_not == update_to_punch_out
        end

        it "does not create a log" do
          timesheet.changelogs.first.should == nil
        end
      end
    end
  end
end
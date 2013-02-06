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
    new_punch_in_time = DateTime.now.utc - 1.hour
    second_new_punch_in_time = DateTime.now.utc - 2.hours    
    new_punch_out_time = DateTime.now.utc + 2.hours
    second_new_punch_out_time = DateTime.now.utc + 3.hours

    context "manager" do
      before { manager.manager = true }


      context "punch in" do
        before(:each) { timesheet.punch_in_management(manager, new_punch_in_time) }

        it "does update punch_in for selected employee" do
          timesheet.punch_in.to_i.should == (new_punch_in_time).to_i
        end

        it "does update change_log IN" do
          timesheet.change_log.should == {"In: #{new_punch_in_time}" => manager.name}.as_json
        end

        context "second punch in" do
          before(:each) { timesheet.punch_in_management(manager, second_new_punch_in_time) }

          it "does update punch_in again for selected employee" do
            timesheet.punch_in.to_i.should == (second_new_punch_in_time).to_i
          end

          it "does update change_log IN again" do
            timesheet.change_log.should == {"In: #{new_punch_in_time}" => manager.name, "In: #{second_new_punch_in_time}" => manager.name}.as_json
          end
        end
      end

      context "punch out" do
        before(:each) { timesheet.punch_out_management(manager, new_punch_out_time) }
        
        it "does update punch_out for selected employee" do
          timesheet.punch_out.to_i.should == new_punch_out_time.to_i
        end

        it "does update change log OUT" do
          timesheet.change_log.should == {"Out: #{new_punch_out_time}" => manager.name}.as_json
        end

        context "second punch out" do
          before(:each) { timesheet.punch_out_management(manager, second_new_punch_out_time) }

          it "does update punch_out again for selected employee" do
            timesheet.punch_out.to_i.should == (second_new_punch_out_time).to_i
          end

          it "does update change_log OUT again" do
            timesheet.change_log.should == {"Out: #{new_punch_out_time}" => manager.name, "Out: #{second_new_punch_out_time}" => manager.name}.as_json
          end
        end
      end
    end

    context "non-manager" do
      before { manager.manager = false }

      context "punch in" do
        before(:each) { timesheet.punch_in_management(manager, new_punch_in_time) }

        it "does not update punch_in for selected employee" do
          timesheet.punch_in.to_i.should_not == new_punch_in_time.to_i
        end

        it "does not update change log IN" do
          timesheet.change_log.should_not == {"In: #{new_punch_in_time}" => manager.name}.as_json
        end
      end

      context "punch out" do
        before(:each) { timesheet.punch_out_management(manager, new_punch_out_time) }

        it "does not update punch_out for selected employee" do
          timesheet.punch_out.to_i.should_not == new_punch_out_time.to_i
        end

        it "does not update change log OUT" do
          timesheet.change_log.should_not == {"Out: #{new_punch_out_time}" => manager.name}.as_json
        end
      end
    end
  end
end
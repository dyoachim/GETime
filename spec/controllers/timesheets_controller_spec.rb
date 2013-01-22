require 'spec_helper'

describe TimesheetsController do
  render_views

  let(:employee) { FactoryGirl.create(:employee) }

  describe "timesheet creation" do

    describe "when logged in with correct employee" do
      it "should create a timesheet" do
        lambda do
          test_log_in(employee)
          post :create, :id => employee
          response.status.should == 302
        end.should change(employee.timesheets, :count).by(1)
      end
    end

    describe "when not logged in" do
      it "should create a timesheet" do
        lambda do
          post :create, :id => employee
          response.status.should == 302
        end.should_not change(employee.timesheets, :count)
      end
    end
  end

  describe "timesheet punch out" do
   let(:timesheet) { FactoryGirl.create(:timesheet, :punch_in => DateTime.now, :employee_id => employee) }

    describe "when logged in with correct employee" do

      it "should update a timesheet" do
        lambda do
          test_log_in(employee)
          post :create, :id => timesheet.id
          put :update, :id => timesheet.id
          response.status.should == 302
          timesheet.punch_out.should change()
        end
      end
    end
    
    describe "when not logged in" do
      it "should not update a timesheet" do
        lambda do
          post :create, :id => timesheet.id
          put :update, :id => timesheet.id
          response.status.should == 302
          timesheet.punch_out.should_not change()
        end
      end
    end
  end
end
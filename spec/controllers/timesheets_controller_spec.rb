require 'spec_helper'

describe TimesheetsController do
  render_views

  let(:employee) { FactoryGirl.create(:employee) }
  let(:manager) { FactoryGirl.create(:manager) }
  let(:timesheet) { employee.timesheets.build(id: 1, punch_in: Time.now ) }

  describe "timesheet creation" do

    context "when logged in with correct employee" do
      it "creates a timesheet" do
        lambda do
          test_log_in(employee)
          post :create, :id => employee.id
          response.should redirect_to(employee_url(employee))
        end.should change(employee.timesheets, :count).by(1)
      end
    end

    context "when not logged in" do
      it "does not create a timesheet" do
        lambda do
          post :create, :id => employee.id
          response.should redirect_to(login_url)
        end.should_not change(employee.timesheets, :count)
      end
    end
  end

  describe "timesheet punch out" do

    before(:each) { timesheet.stub!(:id => 1) }
    
    context "when logged in with correct employee" do
      it "does update a timesheet" do
        lambda do
          test_log_in(employee)
          put :update, :id => timesheet.id
          response.should redirect_to(employee_url(employee))
          timesheet.punch_out.should_not be_nil
        end.call
      end
    end
    
    context "when not logged in" do
      it "does not update a timesheet" do
        lambda do
          put :update, :id => timesheet.id
          response.should redirect_to(login_url)
          timesheet.punch_out.should be_nil
        end.call
      end
    end
  end

  describe "manager time update" do

    context "when manager changes time" do
      it "should be valid" do
        lambda do
          test_log_in(manager)
          timesheet.stub!(:id => 1)
          Timesheet.stub(:find).and_return(timesheet) { timesheet }
          post (:time_change), :id => timesheet.id
          response.should redirect_to(employee_url(employee))
          timesheet.punch_out.should_not be_nil
        end.call
      end
    end
  end
end
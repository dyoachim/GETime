require 'spec_helper'

describe "Timesheet pages" do

  subject { page }

  let(:employee) { FactoryGirl.create(:employee) }

  describe "timesheet creation" do

    describe "when logged in with correct employee" do
      before do
        log_in employee
        visit employee_path(employee)
      end

      it "should create a timesheet" do
        expect { click_button "Clock In" }.to change(Timesheet, :count).by(1)
      end
    end

    describe "when not logged in" do
      before do
        visit employee_path(employee)
      end

      it "should create a timesheet" do
        expect { click_button "Clock In" }.to change(Timesheet, :count).by(0)
      end
    end
  end

  describe "timesheet punch out" do

    describe "when logged in with correct employee" do
      before do
        log_in employee
        visit employee_path(employee)
      end

      it "should update a timesheet" do
        click_button "Clock In"
        timesheet = Timesheet.first
        visit employee_path(employee)
        click_button "Clock Out"
        timesheet.reload.punch_out.utc.to_i.should  == DateTime.now.utc.to_i
      end
    end
  end
end
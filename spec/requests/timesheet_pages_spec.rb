require 'spec_helper'

describe "Timesheet pages" do

  subject { page }

  let(:employee) { FactoryGirl.create(:employee) }

  describe "timesheet creation" do

    context "when logged in with correct employee" do
      it "does create a timesheet" do
        log_in employee
        visit employee_path(employee)
        expect { click_button "Clock In" }.to change(Timesheet, :count).by(1)
      end
    end

    context "when not logged in" do
      it "does not create a timesheet" do
        visit employee_path(employee)
        expect { click_button "Clock In" }.to change(Timesheet, :count).by(0)
      end
    end
  end

  describe "timesheet punch out" do

    context "when logged in with correct employee" do
      it "does update a timesheet" do
        log_in employee
        visit employee_path(employee)
        click_button "Clock In"
        timesheet = Timesheet.first
        visit employee_path(employee)
        click_button "Clock Out"
        timesheet.reload.punch_out.utc.to_i.should  == DateTime.now.utc.to_i
      end
    end
  end
end
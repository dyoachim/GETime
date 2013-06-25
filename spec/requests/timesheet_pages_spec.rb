require 'spec_helper'

describe "Timesheet pages" do

  subject { page }

  let(:employee) { FactoryGirl.create(:employee) }
  before(:each) do 
    log_in employee
    visit employee_path(employee)
  end

  describe "timesheet creation" do

    context "when logged in with correct employee" do
      it "does create a timesheet" do
        expect { click_button "Clock In" }.to change(Timesheet, :count).by(1)
      end
    end
  end

  describe "timesheet punch out" do

    context "when logged in with correct employee" do
      it "does update a timesheet" do
        click_button "Clock In"
        old_out = Timesheet.first.punch_out
        click_button "Clock Out"
        Timesheet.first.reload.punch_out.should_not == old_out
      end
    end
  end
end
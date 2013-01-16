require 'spec_helper'

describe "Timesheet pages" do

  subject { page }

  let(:employee) { FactoryGirl.create(:employee) }
  before { log_in employee }

  describe "timesheet creation" do
    before { visit employees_path }

    describe "with invalid information" do

      it "should not create a timesheet" do
        expect { find('id#clock_in_tester').click }.not_to change(Timesheet, :count)
      end

      describe "error messages" do
        before { find('id#clock_in_tester').click }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do
      it "should create a timesheet" do
        expect { find('id#clock_in_tester').click }.to change(Timesheet, :count).by(1)
      end
    end
  end

  describe "timesheet punch out" do
      describe "with invalid information" do

      it "should not update a timesheet" do
        expect { click_button "Clock Out",  timesheet.reload.punch_out.should  == nil }
      end

      describe "error messages" do
        before { find('id#clock_out_tester').click }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do
      it "should update a timesheet" do
        expect { click_button "Clock Out",  timesheet.reload.punch_out.should  == DateTime.now }
      end
    end
  end
end
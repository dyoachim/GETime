require 'spec_helper'

describe "Timesheet pages" do

  subject { page }

  let(:employee) { FactoryGirl.create(:employee) }

  describe "timesheet creation" do
    before { visit employees_path }

    describe "when not logged in" do
      before { find('clock_in_tester').click }

      it "should not create a timesheet" do
        it { should_not change(Timesheet, :count) }
        it { should have_content('error') } 
      end
    end

    describe "when logged in with correct employee" do
      before { log_in employee }
      it "should create a timesheet" do
        expect { click_button "Clock Out" }.to change(Timesheet, :count).by(1)
      end
    end
  end

  describe "timesheet punch out" do
    
    describe "when not logged in" do
      it "should not update a timesheet" do
        expect { click_button "Clock Out", timesheet.reload.punch_out.should_not  == DateTime.now }
        it { should have_content('error') } 
      end
    end

    describe "when logged in with correct employee" do
      before { log_in employee }
      it "should update a timesheet" do
        expect { click_button "Clock Out",  timesheet.reload.punch_out.should  == DateTime.now }
      end
    end
  end
end
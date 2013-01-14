require 'spec_helper'

describe "Timesheet pages" do

  subject { page }

  let(:employee) { FactoryGirl.create(:employee) }
  before { logged_in employee }

  describe "timesheet creation" do
    before { visit employees_path }

    describe "with invalid information" do

      it "should not create a timesheet" do
        expect { click_button "Post" }.not_to change(Timesheet, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do
      it "should create a timesheet" do
        expect { click_button "Clock In" }.to change(Timesheet, :count).by(1)
      end
    end
  end

  describe "timesheet punch out" do
    #pending
  end
end
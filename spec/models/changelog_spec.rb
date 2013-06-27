require 'spec_helper'

describe Changelog do


let(:timesheet) { FactoryGirl.create(:timesheet, :punch_in => DateTime.now, :punch_out => DateTime.now + 1.hour) }
before { @changelog = timesheet.changelogs.build(:changed_by => "Manager Dave", :old_in => timesheet.punch_in, :old_out => timesheet.punch_out, :new_in => timesheet.punch_in - 1.hour, :new_out => timesheet.punch_out + 1.hour) }

  subject { @changelog }

  it { should respond_to(:timesheet_id) }
  it { should respond_to(:changed_by) }
  it { should respond_to(:old_in) }
  it { should respond_to(:new_in) }
  it { should respond_to(:old_out) }
  it { should respond_to(:new_out) }
  it { should respond_to(:timesheet) }
  its(:timesheet) { should == timesheet }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to timesheet_id" do
      expect do
        Changelog.new(timesheet_id: timesheet.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when timesheet_id is not present" do
    before { @changelog.timesheet_id = nil }
    it { should_not be_valid }
  end

  describe "with blank old_in" do
    before { @changelog.old_in = " " }
    it { should_not be_valid }
  end  

  describe "with blank new_in" do
    before { @changelog.new_in = " " }
    it { should_not be_valid }
  end  

  describe "with blank old_out" do
    before { @changelog.old_out = " " }
    it { should_not be_valid }
  end  

  describe "with blank new_out" do
    before { @changelog.new_out = " " }
    it { should_not be_valid }
  end  

  describe "with blank changed_by" do
    before { @changelog.changed_by = " " }
    it { should_not be_valid }
  end
end
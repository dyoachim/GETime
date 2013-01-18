require 'spec_helper'

describe "Employee pages" do
  
  subject { page }

  describe "index" do

    let(:employee) { FactoryGirl.create(:employee) }

    before(:each) do
      log_in employee
      visit employees_path
    end

    it { should have_selector('title', text: 'All employees') }
    it { should have_selector('h1',    text: 'All employees') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:employee) } }
      after(:all)  { Employee.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each employee" do
        Employee.paginate(page: 1).each do |employee|
          page.should have_selector('li', text: employee.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as a manager" do
        let(:manager) { FactoryGirl.create(:manager) }
        before do
          log_in manager
          visit employees_path
        end

        it { should have_link('delete', href: employee_path(Employee.first)) }
        it "should be able to delete another employee" do
          expect { click_link('delete') }.to change(Employee, :count).by(-1)
        end
        it { should_not have_link('delete', href: employee_path(:manager)) }
      end
    end
  end

  describe "account page" do
    let(:employee) { FactoryGirl.create(:employee) }
    let!(:t1) { FactoryGirl.create(:timesheet, employee: employee, punch_in: DateTime.now, punch_out: (DateTime.now + 1.hour)) }
    let!(:t2) { FactoryGirl.create(:timesheet, employee: employee, punch_in: DateTime.tomorrow, punch_out: (DateTime.tomorrow + 1.hour)) }

    before { visit employee_path(employee) }


    it { should have_selector('h1',    text: employee.name) }
    it { should have_selector("title", text: employee.name) }
    it { should have_content(t1.punch_in) }
    it { should have_content(t2.punch_in) }
    it { should have_content(employee.timesheets.count) }
  end

  describe "add worker page" do 
  	before { visit add_worker_path }

  	it { should have_selector('h1', text: 'Add New Worker')}
  	it { should have_selector('title', text: 'Add New Worker') }
  end

  describe "add worker" do

    before { visit add_worker_path }

    let(:submit) { "Create account" }

    describe "with invalid information" do
      it "should not create an employee" do
        expect { click_button submit }.not_to change(Employee, :count)
      end
    end

    describe "with valid information" do

      before do
        fill_in "Name",         with: "James Bond"
        fill_in "Username",     with: "suave00seven"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      describe "after saving the employee" do
        before { click_button submit }
        let(:employee) { Employee.find_by_username('suave00seven') }

        it { should have_link('Log out') }
      end

      it "should create an employee" do
        expect { click_button submit }.to change(Employee, :count).by(1)
      end
    end
  end

  describe "edit" do
    let(:employee) { FactoryGirl.create(:employee) }
    before do
      log_in employee
      visit edit_employee_path(employee)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your account") }
      it { should have_selector('title', text: "Edit account") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_username) { "new username" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Username",         with: new_username
        fill_in "Password",         with: employee.password
        fill_in 'confirm',          with: employee.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Log out', href: logout_path) }
      specify { employee.reload.name.should  == new_name }
      specify { employee.reload.username.should == new_username }
    end
  end
end
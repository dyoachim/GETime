require 'spec_helper'

describe "Employee pages" do

  let(:employee) { FactoryGirl.create(:employee) }
  
  subject { page }

  describe "index" do

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

      it "does list each employee" do
        Employee.paginate(page: 1).each do |employee|
          if employee.active_employee
            page.should have_selector('li', text: employee.name)
          end
        end
      end

      it "does not list deleted employees" do
        Employee.paginate(page: 1).each do |employee|
          if !employee.active_employee
            page.should_not have_selector('li', text: employee.name)
          end
        end
      end
    end

    describe "delete button" do

      it { should_not have_button('delete') }

      context "when a manager" do
        let(:manager) { FactoryGirl.create(:manager) }
        before do
          log_in manager
          visit employees_path
        end

        it { should have_button('delete') }
        
        it "does not delete another employee" do
          expect { click_button('delete') }.to change(Employee, :count).by(0)
        end
        
        it { should_not have_link('delete', href: employee_path(:manager)) }
      end
    end
  end

  describe "account page" do
    let!(:t1) { FactoryGirl.create(:timesheet, employee: employee, punch_in: Time.now, punch_out: (Time.now + 1.hour)) }
    let!(:t2) { FactoryGirl.create(:timesheet, employee: employee, punch_in: Time.now + 24.hours, punch_out: (Time.now + 25.hours)) }

    before(:each) do
      log_in employee
      visit employee_path(employee)
    end

    it { should have_content(t1.punch_in.in_time_zone(employee.employee_time_zone).strftime("%-I:%M%P, %b %d %Y")) }
    it { should have_content(t2.punch_in.in_time_zone(employee.employee_time_zone).strftime("%-I:%M%P, %b %d %Y")) }
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

    context "with invalid information" do
      it "should not create an employee" do
        expect { click_button submit }.not_to change(Employee, :count)
      end
    end

    context "with valid information" do

      before do
        fill_in "Name",         with: "James Bond"
        fill_in "Username",     with: "suave00seven"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        page.select('(GMT+00:00) UTC', :from => 'timezone')
      end

      describe "after saving the employee" do
        before { click_button submit }
        let(:employee) { Employee.find_by_username('suave00seven') }

        it { should have_link('Log out') }
      end

      it "does create an employee" do
        expect { click_button submit }.to change(Employee, :count).by(1)
      end
    end
  end

  describe "edit" do
    before do
      log_in employee
      visit edit_employee_path(employee)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your account") }
      it { should have_selector('title', text: "Edit account") }
    end

    context "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    context "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_username) { "new username" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Username",         with: new_username
        fill_in "Password",         with: employee.password
        fill_in 'confirm',          with: employee.password
        page.select('(GMT-10:00) Hawaii', :from => 'timezone')

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
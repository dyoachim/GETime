require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Log in') }
    it { should have_selector('title', text: 'Log in') }
  end

  describe "login" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Log in" }

      it { should have_selector('title', text: 'Log in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
    end

    describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    describe "with valid information" do
      let(:employee) { FactoryGirl.create(:employee) }
        before { log_in employee }

      it { should have_selector('title', text: employee.name) }
      
      it { should have_link('Employees',    href: employees_path) }
        it { should have_link('Account',  href: employee_path(employee)) }
      it { should have_link('Settings', href: edit_employee_path(employee)) }
      it { should have_link('Log out', href: logout_path) }

       it { should_not have_link('Log in', href: login_path) }
        
      describe "followed by logout" do
        before { click_link "Log out" }
        it { should have_link('Log in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-logged-in employees" do
      let(:employee) { FactoryGirl.create(:employee) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_employee_path(employee)
          fill_in "Username",    with: employee.username
          fill_in "Password", with: employee.password
          click_button "Log in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit account')
          end
        end
      end

      describe "in the Timesheets controller" do

        describe "submitting to the create action" do
          before { post timesheets_path }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the employee controller" do

        describe "visiting the edit page" do
          before { visit edit_employee_path(employee) }
          it { should have_selector('title', text: 'Log in') }
        end

        describe "submitting to the update action" do
          before { put employee_path(employee) }
          specify { response.should redirect_to(login_path) }
        end

        describe "visiting the employee index" do
          before { visit employees_path }
          it { should have_selector('title', text: 'Log in') }
        end
      end
    end

    describe "as wrong employee" do
      let(:employee) { FactoryGirl.create(:employee) }
      let(:wrong_employee) { FactoryGirl.create(:employee, username: "wrongname") }
      before { log_in employee }

      describe "visiting Employees#edit page" do
        before { visit edit_employee_path(wrong_employee) }
        it { should_not have_selector('title', text: 'Edit employee') }
      end

      describe "submitting a PUT request to the Employees#update action" do
        before { put employee_path(wrong_employee) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-manager employee" do
      let(:employee) { FactoryGirl.create(:employee) }
      let(:non_manager) { FactoryGirl.create(:employee) }

      before { log_in non_manager }

      describe "submitting a DELETE request to the Employees#destroy action" do
        before { delete employee_path(employee) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
end
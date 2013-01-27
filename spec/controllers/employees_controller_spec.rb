require 'spec_helper'

describe EmployeesController do
  render_views

  let(:employee) { FactoryGirl.create(:employee) }
  let(:blank_employee_attributes) {{:name => "", :username => "", :password => "", :password_confirmation => "" }}
  let(:valid_employee_attributes) {{ :name => "New Employee", :username => "employeeexample", :password => "foobar", :password_confirmation => "foobar" }}

  describe "GET 'index'" do

    describe "for non-logged-in employees" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    context "when logged in" do

      it "should be successful" do
        test_log_in(employee)
        get :index
        response.should be_success
      end
    end
  end

  describe "GET 'show'" do

    it "does get successfully" do
      get :show, :id => employee
      response.should be_success
      assigns(:employee).should == employee
    end
  end

  describe "GET 'new'" do

    it "does have input fields", :type => :feature do
      visit add_worker_path
      response.should be_success
      page.should have_selector("input[name='employee[name]'][type='text']")
      page.should have_selector("input[name='employee[username]'][type='text']")
      page.should have_selector("input[name='employee[password]'][type='password']")
      page.should have_selector("input[name='employee[password_confirmation]'][type='password']")
    end
  end

  describe "POST 'create'" do

    context "when failure" do

      it "does not create an employee" do
        lambda do
          post :create, :employee => blank_employee_attributes
        end.should_not change(Employee, :count)
      end

      it "does render the 'new' page" do
        post :create, :employee => blank_employee_attributes
        response.should render_template('new')
      end
    end

    context "when success" do

      it "does create an employee" do
        lambda do
          post :create, :employee => valid_employee_attributes
        end.should change(Employee, :count).by(1)
      end

      it "does redirect to the employee show page and log in" do
        post :create, :employee => valid_employee_attributes
        response.should redirect_to(employee_path(assigns(:employee)))
        flash[:success].should =~ /New employee successfully added/i
        controller.should be_logged_in
      end
    end
  end

  describe "GET 'edit'" do

    it "does get successfully" do
      test_log_in(employee)
      get :edit, :id => employee
      response.should be_success
    end
  end

  describe "PUT 'update'" do

    before(:each) do 
      test_log_in(employee)
    end

    context "when failure" do

      it "does render the 'edit' page" do
        put :update, :id => employee, :employee => blank_employee_attributes
        response.should render_template('edit')
      end
    end

    context "when success" do

      it "does change the employee's attributes" do
        put :update, :id => employee, :employee => valid_employee_attributes
        employee.reload
        employee.name.should  == valid_employee_attributes[:name]
        employee.username.should == valid_employee_attributes[:username]
        response.should redirect_to(employee_path(employee))
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do

    context "when not logged in" do
      
      it "does deny access to 'edit'" do
        get :edit, :id => employee
        response.should redirect_to(login_path)
      end

      it "does deny access to 'update'" do
        put :update, :id => employee, :employee => {}
        response.should redirect_to(login_path)
      end
    end

    context "when logged in" do
      let(:wrong_employee) { FactoryGirl.create(:employee, :username => "employeeexample") }
      before { test_log_in(wrong_employee) }

      it "does require matching employees for 'edit'" do
        get :edit, :id => employee
        response.should redirect_to(root_path)
      end

      it "does require matching employees for 'update'" do
        put :update, :id => employee, :employee => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
require 'spec_helper'

describe EmployeesController do
  render_views

  let(:employee) { FactoryGirl.create(:employee) }

  describe "GET 'index'" do

    describe "for non-logged-in employees" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    describe "for logged-in employees" do

      it "should be successful" do
        test_log_in(employee)
        get :index
        response.should be_success
      end
    end
  end

  describe "GET 'show'" do

    it "should be successful" do
      get :show, :id => employee
      response.should be_success
      assigns(:employee).should == employee
    end
  end

  describe "GET 'new'" do

    it "should have a input fields" do
      get :new
      response.should be_success
      response.should have_selector("input[name='employee[name]'][type='text']")
      response.should have_selector("input[name='employee[username]'][type='text']")
      response.should have_selector("input[name='employee[password]'][type='password']")
      response.should have_selector("input[name='employee[password_confirmation]'][type='password']")
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = {:name => "", :username => "", :password => "", 
                 :password_confirmation => "" }
      end

      it "should not create an employee" do
        lambda do
          post :create, :employee => @attr
        end.should_not change(Employee, :count)
      end

      it "should render the 'new' page" do
        post :create, :employee => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Employee", :username => "employeeexample", :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create an employee" do
        lambda do
          post :create, :employee => @attr
        end.should change(Employee, :count).by(1)
      end

      it "should redirect to the employee show page and log in" do
        post :create, :employee => @attr
        response.should redirect_to(employee_path(assigns(:employee)))
        flash[:success].should =~ /New employee successfully added/i
        controller.should be_logged_in
      end
    end
  end

  describe "GET 'edit'" do

    it "should be successful" do
      test_log_in(employee)
      get :edit, :id => employee
      response.should be_success
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @employee = FactoryGirl.create(:employee)
      test_log_in(@employee)
    end

    describe "failure" do

      @attr = { :name => "", :username => "", :password => "", :password_confirmation => "" }

      it "should render the 'edit' page" do
        put :update, :id => @employee, :employee => @attr
        response.should render_template('edit')
      end
    end

    describe "success" do

      before { @attr = { :name => "New Name", :username => "newusername", 
                  :password => "barbaz", :password_confirmation => "barbaz"} }

      it "should change the employee's attributes" do
        put :update, :id => @employee, :employee => @attr
        @employee.reload
        @employee.name.should  == @attr[:name]
        @employee.username.should == @attr[:username]
        response.should redirect_to(employee_path(@employee))
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do

    describe "for non-signed-in employees" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => employee
        response.should redirect_to(login_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => employee, :employee => {}
        response.should redirect_to(login_path)
      end
    end

    describe "for logged-in employees" do
      let(:wrong_employee) { FactoryGirl.create(:employee, :username => "employeeexample") }
      before { test_log_in(wrong_employee) }

      it "should require matching employees for 'edit'" do
        get :edit, :id => employee
        response.should redirect_to(root_path)
      end

      it "should require matching employees for 'update'" do
        put :update, :id => employee, :employee => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
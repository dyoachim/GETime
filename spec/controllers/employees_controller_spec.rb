require 'spec_helper'

describe EmployeesController do
  render_views

  describe "GET 'index'" do

    describe "for non-logged-in employees" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    describe "for logged-in employees" do

      before(:each) do
        @employee = test_log_in(FactoryGirl.create(:employee))
      end

      it "should be successful" do
        get :index
        response.should be_success
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @employee = FactoryGirl.create(:employee)
    end

    it "should be successful" do
      get :show, :id => @employee
      response.should be_success
    end

    it "should find the right employee" do
      get :show, :id => @employee
      assigns(:employee).should == @employee
    end
  end

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='employee[name]'][type='text']")
    end

    it "should have a username field" do
      get :new
      response.should have_selector("input[name='employee[username]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[name='employee[password]'][type='password']")
    end

    it "should have a password confirmation field" do
      get :new
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

      it "should redirect to the employee show page" do
        post :create, :employee => @attr
        response.should redirect_to(employee_path(assigns(:employee)))
      end

      it "should have a welcome message" do
        post :create, :employee => @attr
        flash[:success].should =~ /New employee successfully added/i
      end

      it "should log the employee in" do
        post :create, :employee => @attr
        controller.should be_logged_in
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @employee = FactoryGirl.create(:employee)
      test_log_in(@employee)
    end

    it "should be successful" do
      get :edit, :id => @employee
      response.should be_success
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @employee = FactoryGirl.create(:employee)
      test_log_in(@employee)
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :username => "", :password => "", :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @employee, :employee => @attr
        response.should render_template('edit')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :username => "newusername", 
                  :password => "barbaz", :password_confirmation => "barbaz"}
      end

      it "should change the employee's attributes" do
        put :update, :id => @employee, :employee => @attr
        @employee.reload
        @employee.name.should  == @attr[:name]
        @employee.username.should == @attr[:username]
      end

      it "should redirect to the employee show page" do
        put :update, :id => @employee, :employee => @attr
        response.should redirect_to(employee_path(@employee))
      end

      it "should have a flash message" do
        put :update, :id => @employee, :employee => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do

    before(:each) do
      @employee = FactoryGirl.create(:employee)
    end

    describe "for non-signed-in employees" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @employee
        response.should redirect_to(login_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @employee, :employee => {}
        response.should redirect_to(login_path)
      end
    end

    describe "for logged-in employees" do

      before(:each) do
        wrong_employee = FactoryGirl.create(:employee, :username => "employeeexample")
        test_log_in(wrong_employee)
      end

      it "should require matching employees for 'edit'" do
        get :edit, :id => @employee
        response.should redirect_to(root_path)
      end

      it "should require matching employees for 'update'" do
        put :update, :id => @employee, :employee => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
FactoryGirl.define do
  	factory :employee do
    	sequence(:name)     { |n| "Person #{n}" }
    	sequence(:username) { |n| "person_#{n}" }
    	password "foobar"
    	password_confirmation "foobar"
      employee_time_zone "UTC"

	    factory :manager do
    		manager true
    	end

	    factory :timesheets do
    		punch_in  Time.now
    		punch_out Time.now + 1.hour
    		employee
  		end
  	end
end

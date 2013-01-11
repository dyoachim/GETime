FactoryGirl.define do
  	factory :employee do
    	sequence(:name)     { |n| "Person #{n}" }
    	sequence(:username) { |n| "person_#{n}" }
    	password "foobar"
    	password_confirmation "foobar"

	    factory :manager do
    		manager true
    	end

	    factory :timesheets do
    		punch_in  DateTime.now
    		punch_out DateTime.now + 1.hour
    		employee
  		end
  	end
end

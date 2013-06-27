# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timesheet do
    punch_in ""
    punch_out ""
    employee_id 1
  end
end

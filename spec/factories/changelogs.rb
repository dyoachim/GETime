# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :changelog do
    timesheet_id 1
    changed_by "MyString"
    old_in ""
    new_in ""
    old_out ""
    new_out ""
  end
end

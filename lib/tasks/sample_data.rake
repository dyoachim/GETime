namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    manager = Employee.create!(name: "Example employee",
                 username: "examplename",
                 password: "foobar",
                 password_confirmation: "foobar")
    manager.toggle!(:manager)
    99.times do |n|
      name  = Faker::Name.name
      username = "example-#{n+1}"
      password  = "password"
      Employee.create!(name: name,
                   username: username,
                   password: password,
                   password_confirmation: password)
    end

    employees = Employee.all(limit: 6)
    50.times do
      punch_in = DateTime.now
      punch_out = DateTime.now + 1.hour
      employees.each { |employee| employee.timesheets.create!(punch_in: punch_in, punch_out: punch_out) }
    end
  end
end

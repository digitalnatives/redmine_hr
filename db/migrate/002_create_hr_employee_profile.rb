class CreateEmployeeProfile < ActiveRecord::Migration
  def up
    User.all.each do |user|
      next if user.hr_employee_profile
      user.hr_create_employee_profile
      puts "Created employee profile for user: " + user.to_s
    end
  end
end

class CreateHrEmployeeProfile < ActiveRecord::Migration
  def up
    User.all.each do |user|
      next if user.hr_employee_profile
      user.create_hr_employee_profile({supervisor_id: 1})
      puts "Created employee profile for user: " + user.to_s
    end
  end
end

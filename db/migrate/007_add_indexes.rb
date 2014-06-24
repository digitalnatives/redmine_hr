class AddIndexes < ActiveRecord::Migration
  def change
    add_index :hr_employee_profiles, :supervisor_id
    add_index :hr_employee_profiles, :user_id
    add_index :hr_holiday_modifiers, :hr_employee_profile_id
    add_index :hr_employee_children, :hr_employee_profile_id
    add_index :hr_holiday_requests, :hr_employee_profile_id
    add_index :hr_holiday_requests, :request_type
    add_index :hr_holiday_requests, :status
    add_index :hr_audits, :hr_holiday_request_id
    add_index :hr_audits, :user_id
  end
end

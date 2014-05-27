class CreateHrHolidayRequests < ActiveRecord::Migration
  def change
    create_table :hr_holiday_requests do |t|
      t.integer :employee_profile_id
      t.date :start_date
      t.date :end_date
      t.boolean :half_day
      t.text :description
      t.string :status
      t.string :type
    end
  end
end

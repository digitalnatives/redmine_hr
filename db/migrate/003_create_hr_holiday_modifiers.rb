class CreateHrHolidayModifiers < ActiveRecord::Migration
  def change
    create_table :hr_holiday_modifiers do |t|
      t.integer :hr_employee_profile_id
      t.date 		:year
      t.integer :value
      t.text 		:description
      t.timestamps
    end
  end
end

class CreateHrHolidayModifiers < ActiveRecord::Migration
  def change
    create_table :hr_holiday_modifiers do |t|
      t.date    :year
      t.integer :value
      t.text    :description
      t.integer :hr_employee_profile_id
      t.timestamps
    end
  end
end

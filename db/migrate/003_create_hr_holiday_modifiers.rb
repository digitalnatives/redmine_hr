class CreateHolidayModifiers < ActiveRecord::Migration
  def change
    create_table :hr_holiday_modifiers do |t|
      t.integer :employee_profile_id
      t.date 		:year
      t.integer :value
      t.text 		:description
    end
  end
end

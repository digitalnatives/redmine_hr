class CreateHrEmployeeChildren < ActiveRecord::Migration
  def change
    create_table :hr_employee_children do |t|
      t.string  :name
      t.date    :birth_date
      t.string  :gender
      t.integer :hr_employee_profile_id
      t.timestamps
    end
  end
end

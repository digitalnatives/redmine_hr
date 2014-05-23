class CreateHrEmployeeProfiles < ActiveRecord::Migration
  def change
    create_table :hr_employee_profiles do |t|
      t.column  :user_id, 		  :integer, :null => false
      t.column  :supervisor_id, :integer, :null => false
      t.boolean :administrator
    end
  end
end

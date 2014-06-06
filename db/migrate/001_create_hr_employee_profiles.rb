class CreateHrEmployeeProfiles < ActiveRecord::Migration
  def change
    create_table :hr_employee_profiles do |t|
      t.column  :gender,          :string,  :default => nil
      t.column  :birth_date,      :date,    :default => nil
      t.column  :employment_date, :date,    :default => nil
      t.column  :user_id,         :integer, :null => false
      t.column  :supervisor_id,   :integer, :null => false
      t.timestamps
    end
  end
end

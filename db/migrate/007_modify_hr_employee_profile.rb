class ModifyHrEmployeeProfile < ActiveRecord::Migration
  def self.up
    add_column :hr_employee_profiles, :gender, :string, :default => nil
    add_column :hr_employee_profiles, :birth_date, :date, :default => nil
    add_column :hr_employee_profiles, :employment_date, :date, :default => nil
  end
end


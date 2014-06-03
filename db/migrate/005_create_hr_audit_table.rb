class CreateHrAuditTable < ActiveRecord::Migration
  def self.up
    create_table :hr_audits do |t|
      t.string  :from
      t.string  :to
      t.integer :user_id
      t.integer :hr_holiday_request_id
      t.timestamps
    end
  end

  def self.down
    drop_table :hr_audits
  end
end

class CreateAuditTable < ActiveRecord::Migration
  def self.up
    create_table :audits do |t|
      t.integer :user_id
      t.integer :hr_holiday_request_id
      t.string  :from
      t.string  :to
      t.timestamps
    end
  end

  def self.down
    drop_table :audits
  end
end

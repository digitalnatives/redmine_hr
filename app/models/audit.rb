class Audit < ActiveRecord::Base
  belongs_to :hr_holiday_request
  belongs_to :user

  def as_json
  	data = super :root => false
  	data[:user] = user.name
  	data
  end
end

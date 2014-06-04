require 'spec_helper'

describe "Mails" do

  before do
    @user = User.create({firstname: 'A', lastname: 'B'})
    @profile = @user.hr_employee_profile
  end

  {
    'planned|request' => 'requested',
    'requested|approve' => 'approved',
    'requested|reject' => 'rejected',
    'approved|withdraw' => 'withdrawn',
    'withdrawn|approve_withdrawn' => 'approved_withdrawn',
    'withdrawn|reject_withdrawn' => 'rejected_withdrawn'
  }.each do |data,method|
    status, event = data.split "|"
    it "should send mail for #{event}" do
      HrMailer.should_receive(method).and_return double(deliver: true)
      request = @profile.hr_holiday_requests.new({
        start_date: Date.today,
        end_date: Date.today,
        status: status,
      })
      request.send(event)
    end
  end
end

require 'spec_helper'

describe HrHolidayRequest do

  let(:options) {{
    start_date: Date.today,
    end_date: Date.tomorrow,
  }}

  let(:past_options) {{
    start_date: Date.yesterday,
    end_date: Date.today
  }}

  let(:profile) { HrEmployeeProfile.create supervisor_id: 0, user_id: 0, birth_date: Date.today, employment_date: Date.today }

  subject { profile.hr_holiday_requests.new(options) }

  states = [
    { event: 'request',           status: 'requested', from: ['planned']               },
    { event: 'withdraw',          status: 'withdrawn', from: ['approved']              },
    { event: 'cancel',            status: 'planned'  , from: ['requested']             },
    { event: 'approve',           status: 'approved' , from: ['requested', 'rejected'] },
    { event: 'remove',            status: 'deleted'  , from: ['requested', 'planned']  },
    { event: 'reject',            status: 'rejected' , from: ['requested', 'approved'] },
    { event: 'approve_withdrawn', status: 'planned'  , from: ['withdrawn']             },
    { event: 'reject_withdrawn',  status: 'approved' , from: ['withdrawn']             }
  ]

  flows = {
    "request -> cancel" => 'planned',
    "request -> remove" => 'deleted',
    "request -> reject" => 'rejected',
    "request -> approve" => 'approved',
    "request -> reject -> approve" => 'approved',
    "request -> approve -> reject" => 'rejected',
    "request -> approve -> withdraw" => 'withdrawn',
    "request -> approve -> withdraw -> approve_withdrawn" => "planned",
    "request -> approve -> withdraw -> reject_withdrawn" => "approved"
  }

  before do
    %w(requested approved withdrawn rejected approved_withdrawn rejected_withdrawn).each do |mail|
      HrMailer.stub(mail) do double(deliver: true) end
    end
  end

  describe "State Machine" do

    flows.each do |name,end_status|
      describe name do
        it "should flow through" do
          lambda {
            name.split(" -> ").each do |method|
              subject.send("#{method}!")
            end
          }.should_not raise_error
          subject.status.should eq end_status
        end
      end
    end

    states.each do |state|
      describe "##{state[:status]}" do

        state[:from].each do |status|
          it "should transition from #{status}" do
            sub = profile.hr_holiday_requests.new(options.merge({status: "#{status}"}))
            sub.send("#{state[:event]}!")
            sub.status.should eq state[:status]
          end
        end

        it "should fail for every other status" do
          (described_class::STATUSES - state[:from]).each do |status|
            sub = profile.hr_holiday_requests.new(options.merge({status: status}))
            lambda { sub.send("#{state[:event]}!") }.should raise_error
          end
        end
      end
    end

    describe "#reject" do
      it "should not transition if the request is in the past" do
        sub = profile.hr_holiday_requests.new(past_options.merge({status: 'requested'}))
        lambda { sub.reject! }.should raise_error
      end
    end
  end
end

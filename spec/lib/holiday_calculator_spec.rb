require 'spec_helper'

module Secretary
end

describe HrHolidayCalculator do

  let(:status)  { 'accepted' }
  let(:request) { double(:request,
    start_date: Date.today,
    end_date: Date.tomorrow,
    status: status
  ) }
  let(:requests) { [request] }
  let(:profile) { double(:profile,
    hr_holiday_requests: double(by_year: requests),
    hr_holiday_modifiers: double(by_year: [
      double(value: 1),
      double(value: -2)
    ])
  ) }
  let(:working_days) { {
    "2014-05-28" => {name: 'Working Day'},
    "2014-05-29" => {name: 'Working Day'}
  } }
  let(:mixed_days) { {
    "2014-05-28" => {name: 'Working Day'},
    "2014-05-29" => {name: 'Half Day'},
    "2014-05-29" => {name: 'Holiday'},
    "2014-05-29" => {name: 'Test'}
  } }

  before do
    Secretary.stub(:ask) do |type,from,to|
      hash = {}
      (((to-from).days.to_i/86400)+1).times do |i|
        hash[i] = {name: 'Working Day'}
      end
      hash
    end
  end

  describe "#calculate_holidays" do
    it "should return the count of working days" do
      Secretary.stub(:ask).and_return working_days
      described_class.calculate_duration(request).should eq 2
    end

    it "should skip non working days" do
      Secretary.stub(:ask).and_return mixed_days
      described_class.calculate_duration(request).should eq 1
    end
  end

  describe "#modifiers" do
    it "should sum modifiers" do
      described_class.send(:sum_modifiers, profile, Date.today).should eq -1
    end
  end

  context "Request Dependent" do

    let(:requests) {[
      double(status: 'accepted'  ,start_date: Date.today, end_date: Date.tomorrow),
      double(status: 'accepted'  ,start_date: Date.today, end_date: Date.today),
      double(status: 'requested' ,start_date: Date.today, end_date: Date.today),
      double(status: 'withdrawn' ,start_date: Date.today, end_date: Date.today),
      double(status: 'planned'   ,start_date: Date.today, end_date: Date.tomorrow),
      double(status: 'planned'   ,start_date: Date.today, end_date: Date.today),
    ]}

    describe "#profile_info" do

      subject { described_class.profile_info(profile,Date.today) }

      it "should return a hash" do
        subject.should be_a Hash
      end

      it "should contain all needed keys" do
        [ :holiday_count,
          :accepted,
          :requested,
          :planned,
          :unused,
          :unused_planned
        ].each do |key|
          subject.keys.should include(key)
        end
      end

      it "should call holiday_count" do
        described_class.should_receive(:holiday_count).once.and_return 0
        subject
      end

      it "should call sum_holidays" do
        described_class.should_receive(:sum_holidays).exactly(3).and_return 0
        subject
      end

      it "should count with holiday modifiers" do
        subject[:holiday_count].should eq -1
      end

      it "should count accepted holidays" do
        subject[:accepted].should eq 3
      end

      it "should count requested holidays" do
        subject[:requested].should eq 1
      end

      it "should count planned holidays" do
        subject[:planned].should eq 3
      end

      it "should count unused holidays" do
        subject[:unused].should eq 0
      end

      it "should count unused_planned holidays" do
        subject[:unused_planned].should eq 0
      end
    end

    describe "#holiday_count" do
      it "should return 0" do
        described_class.holiday_count(nil,nil).should eq 0
      end
    end

    describe "#sum_holidays" do
      it "should select holidays by status" do
        described_class.send(:sum_holidays, requests, :accepted).should eq 3
        described_class.send(:sum_holidays, requests, :requested).should eq 1
        described_class.send(:sum_holidays, requests, :planned).should eq 3
        described_class.send(:sum_holidays, requests, :withdrawn).should eq 1
      end
    end
  end
end

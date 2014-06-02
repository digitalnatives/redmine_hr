require './test/spec_helper'

describe HrHolidayRequest do

  describe "defaults" do
    it "should have default status: planned" do
      subject.status.should eq 'planned'
    end

    it "should have default type: holiday" do
      subject.type.should eq 'holiday'
    end
  end

  describe "validations" do
    it "should be invalid for missing attributes" do
      subject.valid?.should be false
    end

    it "should be invalid for not same year" do
      subject.start_date = 1.year.ago
      subject.end_date = Date.today
      subject.valid?.should be false
      subject.errors[:year].should_not be nil
    end

    it "should be invalid for smaller end date" do
      subject.start_date = Date.today
      subject.end_date = Date.yesterday
      subject.valid?.should be false
      subject.errors[:end_date].should_not be nil
    end

    it "should be invalid for not same date" do
      subject.start_date = Date.today
      subject.end_date = Date.tomorrow
      subject.half_day = true
      subject.valid?.should be false
      subject.errors[:half_day].should_not be nil
    end

    it "should be valid for not half day" do
      subject.start_date = Date.today
      subject.end_date = Date.tomorrow
      subject.valid?.should be true
      subject.errors.count.should eq 0
    end
  end
end

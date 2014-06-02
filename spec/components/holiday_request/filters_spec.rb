require '../../spec_helper'

describe HolidayRequestFilters do

  let(:user) { double(:user, id: 0) }

  describe "#initialize" do
    it "should name selects" do
      subject.year.select['name'].should eq 'year'
      subject.user.select['name'].should eq 'user'
      subject.status.select['name'].should eq 'status'
      subject.supervisor.select['name'].should eq 'supervisor'
    end
  end

  describe "#request" do
    it "should return /create a request object" do
      req = subject.request
      req.should eq subject.request
      req.url.should eq 'hr_holiday_requests/filter_data'
    end
  end

  describe "#scope" do
    it "should hide user" do
      subject.scope(user)
      subject.user.style.display.should eq 'none'
    end

    it "should hide supervisor" do
      subject.scope(user)
      subject.supervisor.style.display.should eq 'none'
    end

    it "should set user_id" do
      subject.scope(user)
      subject.instance_variable_get("@user_id").should eq 0
    end
  end

  describe "#unscope" do
    it "should show user" do
      subject.unscope
      subject.user.style.display.should eq 'inline-block'
    end

    it "should show supervisor" do
      subject.unscope
      subject.supervisor.style.display.should eq 'inline-block'
    end

    it "should remove user_id" do
      subject.unscope
      subject.instance_variable_get("@user_id").should eq nil
    end
  end

  describe "#gather" do
    it "should return the values from fields" do
      data = subject.gather
      data.should have_key(:year)
      data.should have_key(:supervisor)
      data.should have_key(:status)
      data.should have_key(:user)
    end
  end
end

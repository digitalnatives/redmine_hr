require 'spec_helper'

describe HrHolidayCalculator::Hun2014 do

  let(:profile) { HrEmployeeProfile.new data }
  let(:data)    {{
    employment_date: Date.new(2013,01,01),
    birth_date: Date.new(1987,05,28),
    gender: 'male'
  }}

  it "does something" do
    described_class.calculate(profile).should eq 21
  end
end

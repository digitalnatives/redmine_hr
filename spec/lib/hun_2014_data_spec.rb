require 'spec_helper'

HOLIDAY_DATA = [
  { employment_date: '2013/03/01', birth_date: Date.new(1990), children: [], gender: 'female', holidays: 20 },
  { employment_date: '2007/01/01', birth_date: Date.new(1981), children: [], gender: 'male', holidays: 24 },
  { employment_date: '2009/06/16', birth_date: Date.new(1983), children: [], gender: 'male', holidays: 23 },
  { employment_date: '2011/03/01', birth_date: Date.new(1976), children: [], gender: 'female', holidays: 26 },
  { employment_date: '2013/01/10', birth_date: Date.new(1984), children: [], gender: 'male', holidays: 22 },
  { employment_date: '2013/05/09', birth_date: Date.new(1971), children: [], gender: 'female', holidays: 29 },
  { employment_date: '2013/04/01', birth_date: Date.new(1976), children: [], gender: 'male', holidays: 26 },
  { employment_date: '2012/07/23', birth_date: Date.new(1977), children: [{birth_date: Date.new(2010), gender: ''}], gender: 'male', holidays: 28 },
  { employment_date: '2014/01/06', birth_date: Date.new(1971), children: [{birth_date: Date.new(1995), gender: ''},{birth_date: Date.new(2011), gender: ''}], gender: 'male', holidays: 30 },
  { employment_date: '2009/06/16', birth_date: Date.new(1980), children: [{birth_date: Date.new(2012), gender: ''}], gender: 'male', holidays: 26 },
  { employment_date: '2013/07/01', birth_date: Date.new(1983), children: [{birth_date: Date.new(2014), gender: ''}], gender: 'male', holidays: 30 },
  { employment_date: '2012/06/25', birth_date: Date.new(1986), children: [], gender: 'male', holidays: 22 },
  { employment_date: '2012/02/14', birth_date: Date.new(1987), children: [], gender: 'male', holidays: 21 },
  { employment_date: '2014/01/06', birth_date: Date.new(1984), children: [], gender: 'male', holidays: 22 },
  { employment_date: '2009/06/16', birth_date: Date.new(1981), children: [], gender: 'male', holidays: 24 },
  { employment_date: '2013/02/08', birth_date: Date.new(1977), children: [], gender: 'female', holidays: 26 },
  { employment_date: '2014/02/03', birth_date: Date.new(1989), children: [], gender: 'male', holidays: 19 },
  { employment_date: '2014/04/07', birth_date: Date.new(1987), children: [], gender: 'female', holidays: 15 },
  { employment_date: '2014/06/04', birth_date: Date.new(1984), children: [], gender: 'female', holidays: 13 },
  { employment_date: '2014/01/20', birth_date: Date.new(1987), children: [], gender: 'female', holidays: 20 },
  { employment_date: '2014/06/10', birth_date: Date.new(1985), children: [], gender: 'female', holidays: 12 },
  { employment_date: '2014/07/07', birth_date: Date.new(1982), children: [], gender: 'female', holidays: 11 },
]

describe 'Hun2014 - with data' do

  before do
    HrHolidayCalculator::Hun2014.stub(:year).and_return Date.new(2014,01,01)
  end

  HOLIDAY_DATA.each do |data|
    holidays = data.delete(:holidays)
    children = data.delete(:children)

    profile = HrEmployeeProfile.new data
    children = children.map do |child| HrEmployeeChild.new child end

    it "should calculate for profile #{data}" do
      profile.stub(:hr_employee_children).and_return children
      HrHolidayCalculator::Hun2014.calculate(profile).should eq holidays
    end
  end
end

require 'spec_helper'

this_year = Date.today.year

describe HrHolidayCalculator::Hun2014 do

  before do
    described_class.instance_variable_set("@year", Date.today)
  end

  describe "extra_from_age" do
    it "should return 5 for 0..17" do
      (0..17).each do |i|
        described_class.extra_from_age(i).should eq 5
      end
    end

    it "should return 0 for 18..24" do
      (18..24).each do |i|
        described_class.extra_from_age(i).should eq 0
      end
    end

    it "should return 1 for 25..27" do
      (25..27).each do |i|
        described_class.extra_from_age(i).should eq 1
      end
    end

    it "should return 2 for 28..30" do
      (28..30).each do |i|
        described_class.extra_from_age(i).should eq 2
      end
    end

    it "should return 3 for 31..32" do
      (31..32).each do |i|
        described_class.extra_from_age(i).should eq 3
      end
    end

    it "should return 4 for 33..34" do
      (33..34).each do |i|
        described_class.extra_from_age(i).should eq 4
      end
    end

    it "should return 5 for 35..37" do
      (35..36).each do |i|
        described_class.extra_from_age(i).should eq 5
      end
    end

    it "should return 6 for 37..38" do
      (37..38).each do |i|
        described_class.extra_from_age(i).should eq 6
      end
    end

    it "should return 7 for 39..40" do
      (39..40).each do |i|
        described_class.extra_from_age(i).should eq 7
      end
    end

    it "should return 8 for 41..42" do
      (41..42).each do |i|
        described_class.extra_from_age(i).should eq 8
      end
    end

    it "should return 9 for 43..44" do
      (43..44).each do |i|
        described_class.extra_from_age(i).should eq 9
      end
    end

    it "should return 10 for 45.." do
      (45..50).each do |i|
        described_class.extra_from_age(i).should eq 10
      end
    end
  end

  describe "extra_from_children" do

    let(:profile0) { double gender: 'male', children: []}
    let(:profile1) { double gender: 'male', children: [child1]}
    let(:profile2) { double gender: 'male', children: [child1,child2]}
    let(:profile3) { double gender: 'male', children: [child1,child2,child3]}
    let(:profile4) { double gender: 'male', children: [child4]}
    let(:profile5) { double gender: 'male', children: [child5]}
    let(:profile6) { double gender: 'male', children: [child5,child5]}
    let(:profile7) { double gender: 'male', children: [child5,child5,child5]}
    let(:profile8) { double gender: 'female', children: [child5]}

    let(:child1)  { double age: 10, birth_date: Date.new(this_year - 10,01,01) }
    let(:child2)  { double age: 16, birth_date: Date.new(this_year - 16,01,01) }
    let(:child3)  { double age: 8,  birth_date: Date.new(this_year - 8,01,01)  }
    let(:child4)  { double age: 17, birth_date: Date.new(this_year - 17,01,01) }
    let(:child5)  { double age: 0,  birth_date: Date.new(this_year,01,01)   }

    it "should return 0 for 0 children" do
      described_class.extra_from_children(profile0).should eq 0
    end

    it "should return 2 for 1 children" do
      described_class.extra_from_children(profile1).should eq 2
    end

    it "should return 4 for 2 children" do
      described_class.extra_from_children(profile2).should eq 4
    end

    it "should return 7 for more than 2" do
      described_class.extra_from_children(profile3).should eq 7
    end

    it "should return 0 if children are older than 16 years" do
      described_class.extra_from_children(profile4).should eq 0
    end

    it "should return 7 for 1 newborn children (male)" do
      described_class.extra_from_children(profile5).should eq 7
    end

    it "should return 11 for 2 newborn children (male)" do
      described_class.extra_from_children(profile6).should eq 11
    end

    it "should return 14 for 3 newborn children (male)" do
      described_class.extra_from_children(profile7).should eq 14
    end

    it "shouldn't calculate with newborns for female" do
      described_class.extra_from_children(profile8).should eq 2
    end
  end

  describe "calcualte" do
    let(:profile) {
      double({
        age: 20,
        children: [],
        gender: 'male',
        employment_date: Date.today.beginning_of_year + 365/2
      })
    }

    let(:profile2) {
      double({
        age: 20,
        children: [],
        gender: 'male',
        employment_date: Date.new(1920,01,01)
      })
    }

    it "should calculate extra from age" do
      described_class.should_receive(:extra_from_age).and_return 0
      described_class.calculate profile
    end

    it "should calculate extra from children" do
      described_class.should_receive(:extra_from_children).and_return 0
      described_class.calculate profile
    end

    it "should calculate portion from employment date" do
      described_class.calculate(profile).should eq 10
    end

    it "shouldn't calculate portion if emplayment date isnt this year" do
      described_class.calculate(profile2).should eq 20
    end
  end
end

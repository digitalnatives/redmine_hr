require '../spec_helper'

describe HolidayModifiersController do

  let(:profile)  { double(id: 0, holiday_modifiers: [modifier]) }
  let(:modifier) { double(id: 0) }
  let(:base)     { double(find: double(value: true)) }

  before do
    subject.instance_variable_set('@base',base)
  end

  describe "#submit" do
    it "should return nil if there is no modifier" do
      subject.submit.should eq nil
    end

    it "should update the modifier" do
      subject.instance_variable_set("@holiday_modifier",modifier)
      subject.instance_variable_set("@profile",profile)

      subject.should receive(:gather)
      subject.should receive(:redirect).with "profiles/0"
      modifier.should receive(:update) do |&block| block.call end
      subject.submit
    end
  end

  describe "#delete" do
    it "should delete the modifier" do
      subject.instance_variable_set("@holiday_modifier",modifier)
      subject.instance_variable_set("@profile",profile)

      subject.should receive(:redirect).with "profiles/0"
      subject.should receive(:getModifier) do |&block| block.call end
      modifier.should receive(:destroy) do |&block| block.call end
      subject.delete({id: 0})
    end
  end

  describe "#delete" do
    it "should get the modifier and display edit page" do
      subject.should receive(:render).with  'views/holiday_modifier/edit', nil
      subject.should receive(:getModifier) do |&block| block.call end
      subject.edit({id: 0})
    end
  end

  describe "#getModifier" do
    it "should get the modifier and profile" do

      EmployeeProfile.should receive(:find) do |&block| block.call profile end
      block = -> {}
      block.should receive(:call)
      subject.getModifier({id: 0, modiferId: 0},&block)
      subject.instance_variable_get("@profile").should eq profile
      subject.instance_variable_get("@holiday_modifier").should eq modifier
    end
  end
end

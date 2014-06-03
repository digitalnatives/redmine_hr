require '../spec_helper'

describe EmployeeChildrenController do

  let(:profile)  { double(id: 0, employee_children: [employee_child]) }
  let(:employee_child) { double(id: 0) }
  let(:base)     { double(find: double(value: true)) }

  before do
    subject.instance_variable_set('@base',base)
  end

  describe "#submit" do
    it "should return nil if there is no employee child" do
      subject.submit.should eq nil
    end

    it "should update the employee child" do
      subject.instance_variable_set("@employee_child",employee_child)
      subject.instance_variable_set("@profile",profile)

      subject.should receive(:gather)
      subject.should receive(:redirect).with "profiles/0"
      employee_child.should receive(:update) do |&block| block.call end
      subject.submit
    end
  end

  describe "#delete" do
    it "should delete the employee child" do
      subject.instance_variable_set("@employee_child",employee_child)
      subject.instance_variable_set("@profile",profile)

      subject.should receive(:redirect).with "profiles/0"
      subject.should receive(:getChild) do |&block| block.call end
      employee_child.should receive(:destroy) do |&block| block.call end
      subject.delete({id: 0})
    end
  end

  describe "#delete" do
    it "should get the modifier and display edit page" do
      subject.should receive(:render).with  'views/employee_child/edit', nil
      subject.should receive(:getChild) do |&block| block.call end
      subject.edit({id: 0})
    end
  end

  describe "#getChild" do
    it "should get the modifier and profile" do

      EmployeeProfile.should receive(:find) do |&block| block.call profile end
      block = -> {}
      block.should receive(:call)
      subject.getChild({id: 0, modiferId: 0},&block)
      subject.instance_variable_get("@profile").should eq profile
      subject.instance_variable_get("@employee_child").should eq employee_child
    end
  end
end

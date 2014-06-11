require '../spec_helper'

describe ProfilesController do

  let(:modifier) { double(update: true)              }
  let(:base)     { double(find: double(value: true)) }
  let(:profile)  { double(id: 0, supervisors: [], data: {})    }

  before do
    CurrentUser.admin = true
    subject.instance_variable_set('@base',base)
  end

  describe "#edit" do
    it "should get profile and render edit" do
      EmployeeProfile.should receive(:all) do |&block| block.call [] end
      subject.instance_variable_set("@profile", profile)
      subject.should receive(:getProfile) do |&block| block.call profile end
      subject.should receive(:render).with 'views/employee_profile/edit', profile
      subject.edit({id: 0})
    end
  end

  describe "#show" do
    it "should get profile and render show" do
      subject.should receive(:getProfile) do |&block| block.call end
      subject.should receive(:render).with 'views/employee_profile/show', nil
      subject.show({id: 0})
    end
  end

  describe "#index" do
    it "should get profiles and render index" do
      EmployeeProfile.should receive(:all) do |&block| block.call [] end
      subject.should receive(:render).with 'views/employee_profile/index', {profiles: []}
      subject.index
    end
  end

  describe "#getProfile" do
    before do
      EmployeeProfile.should receive(:find) do |&block| block.call "test" end
    end

    it 'should set profile' do
      subject.getProfile({id: 0})
      subject.instance_variable_get("@profile").should eq "test"
    end

    it "should call the block" do
      proc = -> {}
      proc.should receive(:call)
      subject.getProfile({id: 0},&proc)
    end
  end

  describe "#submit" do
    it "should return with nil if there is no profile" do
      subject.should_not receive(:gater)
      subject.submit.should eq nil
    end

    it "should update the profile" do
      subject.instance_variable_set('@profile',profile)
      profile.should receive(:update) do |&block|
        block.call
      end
      subject.should receive(:gather)
      subject.should receive(:redirect).with "profiles/0"
      subject.submit
    end
  end
end

require '../spec_helper'

describe ProfilesController do

  let(:modifier) { double(update: true)              }
  let(:base)     { double(find: double(value: true)) }
  let(:profile)  { double(id: 0)                     }

  before do
    subject.instance_variable_set('@base',base)
  end

  describe "submit" do
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

  describe "addModifier" do
    before do
      HolidayModifier.should receive(:new).and_return modifier
      subject.instance_variable_set('@profile',profile)
    end

    it "should create a new modifier" do
      subject.addModifier
    end

    it "should update the modifier" do
      modifier.should receive(:update)
      subject.addModifier
    end
  end
end

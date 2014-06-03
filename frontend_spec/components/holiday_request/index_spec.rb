require '../../spec_helper'

describe HolidayRequestIndex do
  describe "#scop" do
    it 'should call filters#scope' do
      subject.filters.should receive(:scope).with('a')
      subject.scope 'a'
    end
  end
end

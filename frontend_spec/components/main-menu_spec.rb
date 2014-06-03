require '../spec_helper'

describe MainMenu do

  describe "#initialize" do
    it "should create menu items" do
      sub = described_class.new({test: 'a', link: 'b'})
      sub.ul.children.length.should eq 2

      DOM::Document.find('a[href=a]').should_not be nil
      DOM::Document.find('a[href=a]').text.should eq 'test'

      DOM::Document.find('a[href=b]').should_not be nil
      DOM::Document.find('a[href=b]').text.should eq 'link'
    end
  end
end

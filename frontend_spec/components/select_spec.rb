require '../spec_helper'

describe Select do
  describe "#options=" do
    it "should create an empty option" do
      subject.options = []
      subject.select.children.length.should eq 1
    end

    it "should create options from data" do
      subject.options = [['a','b']]
      subject.select.children.length.should eq 2
      subject.select.find('option[value=a]').text.should eq "b"
    end
  end

  describe "#text=" do
    it "should set text of the label" do
      subject.text = 'label'
      subject.label.text.should eq 'label:'
    end
  end
end

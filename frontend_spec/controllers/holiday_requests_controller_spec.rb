require '../spec_helper'

describe HolidayRequestsController do

  let(:request) { subject.instance_variable_get("@holiday_request") }
  let(:index)   { subject.instance_variable_get("@index") }
  let(:filters) { double :filters }

  describe "#initialize" do
    it 'should listen on events' do
      subject.base.listeners[:change].length.should eq 2
      subject.base.listeners[:submit].length.should eq 1
      subject.base.listeners[:click].length.should eq 2
    end

    it "should initialize index" do
      index.should_not eq nil
    end

    it "should intiailize xhr" do
      subject.xhr.should_not eq nil
    end
  end

  describe "#mine" do

    before do
      index.should receive(:scope)
      index.should receive(:filters).and_return filters
      filters.should receive(:update) do |&block| block.call end
      subject.should receive(:update)
      subject.should receive(:insertIndex)
    end

    it "should do before" do
      subject.mine
    end
  end

  describe "#index" do

    before do
      index.should receive(:unscope)
      index.should receive(:filters).and_return filters
      filters.should receive(:update) do |&block| block.call end
      subject.should receive(:insertIndex)
      subject.should receive(:update)
    end

    it "should do before" do
      subject.index
    end
  end

  describe "#edit" do
    it "should call getRequest" do
      subject.should receive(:getRequest)
      subject.edit
    end

    it "should render edit page" do
      subject.should receive(:getRequest) do |&block| block.call end
      subject.should receive(:renderEdit)
      subject.edit
    end
  end

  describe "#show" do
    it "should call getRequest" do
      subject.should receive(:getRequest)
      subject.show
    end

    it "should render show page" do
      subject.should receive(:getRequest) do |&block| block.call end
      subject.should receive(:render).with 'views/holiday_request/show', nil
      subject.show
    end
  end

  describe "#new" do
    it "should create new request" do
      subject.should receive(:renderEdit)
      subject.new
      subject.instance_variable_get("@holiday_request").should_not be nil
    end

    it "should render edit page" do
      subject.should receive(:renderEdit)
      subject.new
    end
  end

  describe "#update" do
    before do
      index.should receive(:gather)
      HolidayRequest.should receive(:all) do |&block|
        block.call []
      end
    end

    it "should get app requests that match the params" do
      subject.update
    end

    it "should render requests" do
      subject.update
      index.content.html.should_not be nil
    end
  end

  describe "#submit" do
    before do
      subject.instance_variable_set("@holiday_request", HolidayRequest.new({profiles: []}))
      subject.should receive(:gather).at_least(1).times.and_return({})
    end

    it "should update request" do
      request.should receive(:update)
      subject.submit
    end

    it "should render errors" do
      request.should receive(:errors).at_least(1).times.and_return({error: ['asd']})
      request.should receive(:update) do |&block| block.call end
      subject.should receive(:render)
      subject.submit
    end

    it "should redirect if there are no errors" do
      request.should receive(:update) do |&block| block.call end
      request.should receive(:errors).at_least(1).times
      subject.should receive(:redirect)
      subject.submit
    end
  end

  describe "#onButtonClick" do
    before do
      subject.instance_variable_set("@holiday_request", HolidayRequest.new())
      request.should receive(:merge)
      subject.should receive(:render)
      subject.should receive(:updateRequest) do |&block| block.call end
    end

    it "should update request" do
      subject.onButtonClick double(:event,target: {action: 'planned'})
    end

    it "should render show page" do
      subject.onButtonClick double(:event,target: {action: 'planned'})
    end
  end

  describe "#onTrClick" do
    it "should update request" do
      subject.should receive(:update)
      subject.should receive(:updateRequest) do |&block| block.call end
      subject.onTrClick double(:event,target: double(:[] => 'planned', id: 0))
    end
  end

  describe "#onChange" do
    before do
      subject.render 'views/holiday_request/edit', HolidayRequest.new({
        profiles: [],
        audits: []
      })
    end

    it "should disable end date if the checkbox is checked" do
      subject.base.find('input[type=checkbox]').checked = true
      subject.onChange
      subject.base.find('[name=end_date]').disabled.should eq true
    end

    it "should disable copy start_date to end_date if the checkbox is checked" do
      subject.base.find('input[type=checkbox]').checked = true
      subject.base.find('[name=start_date]').value = '2015/02/02'
      subject.onChange
      subject.base.find('[name=end_date]').value.should eq '2015/02/02'
      subject.base.find('[name=end_date]').disabled.should eq true
    end
  end

  describe "#onChangeSelect" do
    it "should update if select given" do
      subject.should receive(:update)
      subject.onChangeSelect double(:event,target: double(tag: 'select'))
    end

    it "should not update if not select given" do
      subject.should_not receive(:update)
      subject.onChangeSelect double(:event,target: double(tag: 'a'))
    end
  end

  describe "#insertIndex" do
    it "should empty base and insert title and index" do
      subject.base.should receive(:empty)
      subject.base.should receive(:<<).twice.and_call_original
      subject.insertIndex 'asd'
      index.parent.should eq subject.base
      subject.base.children.first.text.should eq 'asd'
    end
  end

  describe "#updateRequest" do
    it "should set url and update request" do
      subject.xhr.should receive(:url=).with "/hr_holiday_requests/0/planned"
      subject.xhr.should receive(:get)
      subject.updateRequest(0, 'planned')
    end
  end

  describe "#getRequest" do
    it "should get request" do
      HolidayRequest.should receive(:find) do |&block| block.call 'a' end
      subject.getRequest({id: 0})
      request.should eq 'a'
    end
  end

  describe "#renderEdit" do

    before do
      subject.instance_variable_set("@holiday_request", HolidayRequest.new())
      subject.should receive(:render)
    end

    it "should get all profiles for admin" do
      EmployeeProfile.should receive(:all) do |&block| block.call [] end
      CurrentUser.should receive(:[]).and_return true
      subject.renderEdit
    end

    it "should set CurrentProfile for user" do
      CurrentUser.should receive(:[]).and_return nil
      request.data[:profiles].should eq nil
      subject.renderEdit
    end
  end
end

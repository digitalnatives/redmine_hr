require '../../spec_helper'

describe HolidayRequestFilters do

  let(:user) { double(:user, id: 0) }

  describe "#initialize" do
    it "should name selects" do
      subject.year.select['name'].should eq 'year'
      subject.user.select['name'].should eq 'user'
      subject.status.select['name'].should eq 'status'
      subject.supervisor.select['name'].should eq 'supervisor'
    end
  end

  describe "#request" do
    it "should return /create a request object" do
      req = subject.request
      req.should eq subject.request
      req.url.should eq 'hr_holiday_requests/filter_data'
    end
  end

  describe "#scope" do
    it "should hide user" do
      subject.scope(user)
      subject.user.style.display.should eq 'none'
    end

    it "should hide supervisor" do
      subject.scope(user)
      subject.supervisor.style.display.should eq 'none'
    end

    it "should set user_id" do
      subject.scope(user)
      subject.instance_variable_get("@user_id").should eq 0
    end
  end

  describe "#unscope" do
    it "should show user" do
      subject.unscope
      subject.user.style.display.should eq 'inline-block'
    end

    it "should show supervisor" do
      subject.unscope
      subject.supervisor.style.display.should eq 'inline-block'
    end

    it "should remove user_id" do
      subject.unscope
      subject.instance_variable_get("@user_id").should eq nil
    end
  end

  describe "#gather" do
    it "should return the values from fields" do
      data = subject.gather
      data.should have_key(:year)
      data.should have_key(:supervisor)
      data.should have_key(:status)
      data.should have_key(:user)
    end
  end

  describe "update" do
    it "should call get with with user id if scoped" do
      subject.request.should receive(:get).with({ user: 0 })
      subject.scope user
      subject.update
    end

    it "should call get with empty params if unscoped" do
      subject.request.should receive(:get).with({})
      subject.update
    end

    context 'with data' do

      let(:response) { double(:response, json: {
        month: ['0','1','2'],
        year: ['2014','2014','2015'],
        status: ['planned','planned','requested'],
        profiles: [
          {
            id: 0,
            user: {firstname: 'A', lastname: 'B'},
            supervisor: {firstname: 'C', lastname: 'D', id: 1},
          },
          {
            id: 0,
            user: {firstname: 'A', lastname: 'B'},
            supervisor: {firstname: 'C', lastname: 'D', id: 1},
          }
        ]
      })}

      before do
        subject.request.should receive(:get) do |&block|
          block.call response
        end
      end

      it "should gather years as unique" do
        subject.update
        subject.year.options.should eq [['2014','2014'],['2015','2015']]
      end

      it "should gather statuses as unique" do
        subject.update
        subject.status.options.should eq [
          ['planned',  t("hr.holiday_request.statuses.planned")],
          ['requested',t("hr.holiday_request.statuses.requested")]
        ]
      end

      it "should gather users as unique" do
        subject.update
        subject.user.options.should eq [[0,'A B']]
      end

      it "should gather supervisors as unique" do
        subject.update
        subject.supervisor.options.should eq [[1,'C D']]
      end
    end
  end
end

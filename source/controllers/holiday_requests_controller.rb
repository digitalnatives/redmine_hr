require 'views/holiday_request/edit'
require 'views/holiday_request/list'
require 'views/holiday_request/show'
require 'views/flash'

class Select < Fron::Component
  tag 'select-field'

  component :label, 'label'
  component :select, 'select'

  delegate :value, :select

  def text=(value)
    @label.text = "#{value}:"
  end

  def options=(data)
    @select.empty
    @select << DOM::Element.new("option[value=] All")

    data.each do |value|
      @select << DOM::Element.new("option[value=#{value[0]}] #{value[1]}")
    end
  end
end

class HolidayRequestFilters < Fron::Component
  tag 'filters'

  component :year,       Select, {text: 'Year'}
  component :user,       Select, {text: 'User'}
  component :status,     Select, {text: 'Status'}
  component :supervisor, Select, {text: 'Supervisor'}

  def request
    @request ||= Fron::Request.new('hr_holiday_requests/filter_data')
  end

  def gather
    {
      year: @year.value,
      supervisor: @supervisor.value,
      status: @status.value,
      user: @user.value
    }
  end

  def update(&block)
    request.get nil do |response|

      @year.options   = response.json[:year].map { |year| [year,year] }
      @status.options = response.json[:status].map do |status|
        [status,status]
      end

      @user.options = response.json[:profiles]
      .map  { |p| [p[:id],"#{p[:user][:firstname]} #{p[:user][:lastname]}"] }
      .uniq { |u| u[0]   }

      @supervisor.options = response.json[:profiles]
      .map  { |p| p[:supervisor] }.compact
      .uniq { |u| u[:id]         }
      .map  { |u| [u[:id], "#{u[:firstname]} #{u[:lastname]}"] }

      block.call if block_given?
    end
  end
end

class HolidayRequestIndex < Fron::Component
  tag 'index'

  component :filters, HolidayRequestFilters
  component :content, 'div'

  delegate :gather, :filters
end

class HolidayRequestsController < ApplicationController

  route ":id/edit", :edit
  route :new, :new
  route ":id", :show
  route :index

  resource HolidayRequest

  base Content

  def initialize
    super

    @index = HolidayRequestIndex.new
    @xhr = Fron::Request.new

    @base.on 'change' do |e|
      if e.target.tag == 'select'
        update
      end
    end

    @base.on 'change' do
      input = @base.find('input[type=checkbox]')
      break unless input
      end_date = @base.find('[name=end_date]')
      end_date.disabled = input.checked
      if input.checked
        end_date.value = @base.find('[name=start_date]').value
      end
    end

    @base.delegate 'click', '[action]' do |e|
      @xhr.url = "/hr_holiday_requests/#{@request.id}/#{e.target['action']}"
      @xhr.get do |response|
        @request.merge response.json
        render 'views/holiday_request/show', @request
      end
    end

    @base.on :submit do |e|
      e.stop
      submit
    end
  end

  def update
    HolidayRequest.all @index.gather do |requests|
      @index.content.html = Template['views/holiday_request/list'].render requests
    end
  end

  def index
    @base.empty
    @base << @index
    @index.filters.update do
      update
    end
  end

  def submit
    @request.update gather do
      if @request.errors
        render 'views/holiday_request/edit', @request.clone(gather)
      else
        redirect "holiday_requests/#{@request.id}"
      end
    end
  end

  def edit(params)
    getRequest params do
      renderEdit
    end
  end

  def show(params)
    getRequest params do
      render 'views/holiday_request/show', @request
    end
  end

  def new
    @request = self.class.klass.new({
      half_day: false
    })
    renderEdit
  end

  private

  def getRequest(params,&block)
    HolidayRequest.find params[:id] do |request|
      @request = request
      block.call
    end
  end

  def renderEdit
    if CurrentUser[:admin]
      EmployeeProfile.all do |profiles|
        @request.data[:profiles] = profiles
        render 'views/holiday_request/edit', @request
      end
    else
      @request.data[:profiles] = [CurrentProfile]
      render 'views/holiday_request/edit', @request
    end
  end
end

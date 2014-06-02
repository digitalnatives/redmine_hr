require 'components/holiday_request/filters'
require 'components/holiday_request/index'
require 'views/holiday_request/edit'
require 'views/holiday_request/list'
require 'views/holiday_request/show'
require 'views/flash'

class HolidayRequestsController < ApplicationController

  route ":id/edit", :edit
  route "mine",     :mine
  route "new",      :new
  route ":id",      :show
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

    @base.delegate 'click', 'tr [action]' do |e|
      updateRequest e.target.id, e.target['action'] do
        update
      end
    end

    @base.delegate 'click', 'button[action]' do |e|
      updateRequest @request.id, e.target['action'] do |data|
        @request.merge data
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

  def mine
    @base.empty
    @base << @index
    @index.scope ::CurrentProfile
    @index.filters.update do
      update
    end
  end

  def index
    @base.empty
    @base << @index
    @index.unscope
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

  def updateRequest(id,action,&block)
    @xhr.url = "/hr_holiday_requests/#{id}/#{action}"
    @xhr.get do |response|
      block.call response.json
    end
  end

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

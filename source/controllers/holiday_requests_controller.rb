require 'components/holiday_request/filters'
require 'components/holiday_request/index'
require 'views/holiday_request/edit'
require 'views/holiday_request/list'
require 'views/holiday_request/show'
require 'views/flash'

class HolidayRequestsController < ApplicationController
  attr_reader :base, :xhr

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
    @xhr   = Fron::Request.new

    @base.delegate :click, 'button[name=cancel]' do |e|
      e.stop
      if @holiday_request && !@holiday_request.dirty?
        redirect "#profiles/#{@holiday_request.hr_employee_profile_id}"
      else
        if CurrentUser.admin || CurrentUser[:supervisor]
          redirect "#holiday_requests/"
        else
          redirect "#holiday_requests/mine"
        end
      end
    end

    @base.on :change do |e| onChangeSelect(e) end
    @base.on :change do |e| onChange          end
    @base.on :submit do |e| e.stop; submit    end

    @base.delegate :click, 'tr [action]'    do |e| onTrClick(e)     end
    @base.delegate :click, 'button[action]' do |e| onButtonClick(e) end
  end

  def mine
    insertIndex t('hr.my_holiday_requests.title')
    @index.scope ::CurrentProfile
    @index.filters.update do
      update
    end
  end

  def index
    insertIndex t('hr.holiday_requests.title')
    @index.unscope
    @index.filters.update do
      update
    end
  end

  def edit(params)
    getRequest params do
      renderEdit
    end
  end

  def show(params)
    getRequest params do
      render 'views/holiday_request/show', @holiday_request
    end
  end

  def new
    @holiday_request = self.class.klass.new({
      half_day: false
    })
    renderEdit
  end

  private

  def update
    @index.loading = true
    HolidayRequest.all @index.gather do |requests|
      @index.content.html = Template['views/holiday_request/list'].render requests
    end
  end

  def submit
    @holiday_request.update gather do
      if @holiday_request.errors
        render 'views/holiday_request/edit', @holiday_request.clone(gather)
      else
        redirect "holiday_requests/#{@holiday_request.id}"
      end
    end
  end

  def onButtonClick(e)
    updateRequest @holiday_request.id, e.target['action'] do |data|
      @holiday_request.merge data
      render 'views/holiday_request/show', @holiday_request
    end
  end

  def onTrClick(e)
    updateRequest e.target.id, e.target['action'] do
      update
    end
  end

  def onChange
    input = @base.find('input[type=checkbox]')
    return unless input
    end_date = @base.find('[name=end_date]')
    end_date.disabled = input.checked
    return unless input.checked
    end_date.value = @base.find('[name=start_date]').value
  end

  def onChangeSelect(e)
    update if e.target.tag == 'select'
  end

  def insertIndex(title)
    @base.empty
    @base << DOM::Element.new("h2 #{title}")
    @base << @index
  end

  def updateRequest(id,action,&block)
    @xhr.url = "/hr_holiday_requests/#{id}/#{action}"
    @xhr.get do |response|
      block.call response.json if block_given?
    end
  end

  def getRequest(params,&block)
    HolidayRequest.find params[:id] do |request|
      @holiday_request = request
      block.call if block_given?
    end
  end

  def renderEdit
    if CurrentUser[:admin]
      EmployeeProfile.all do |profiles|
        @holiday_request.data[:profiles] = profiles
        render 'views/holiday_request/edit', @holiday_request
      end
    else
      isMe = @holiday_request.hr_employee_profile_id == CurrentProfile[:id]
      profile = if isMe
        CurrentProfile
      else
        firstname, lastname = @holiday_request.user.split " "
        EmployeeProfile.new({
          holiday_modifiers: [],
          employee_children: [],
          id: @holiday_request.hr_employee_profile_id,
          user: { firstname: firstname, lastname: lastname }
        })
      end
      @holiday_request.data[:profiles] = [profile]
      render 'views/holiday_request/edit', @holiday_request
    end
  end
end

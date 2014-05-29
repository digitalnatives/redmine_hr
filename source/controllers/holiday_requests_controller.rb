require 'views/holiday_request/edit'
require 'views/holiday_request/show'
require 'views/flash'

class HolidayRequestsController < ApplicationController

  route ":id/edit", :edit
  route :new, :new
  route ":id", :show

  resource HolidayRequest

  base Content

  def initialize
    super

    @xhr = Fron::Request.new

    @base.on 'change' do
      input = @base.find('input[type=checkbox]')
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

require 'views/holiday_request/edit'
require 'views/flash'

class HolidayRequestsController < ApplicationController

  route ":id/edit", :edit
  route :new, :new

  resource HolidayRequest

  base Content

  def initialize
    super

    @base.on 'change' do
      input = @base.find('input[type=checkbox]')
      end_date = @base.find('[name=end_date]')
      end_date.disabled = input.checked
      if input.checked
        end_date.value = @base.find('[name=start_date]').value
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
        redirect "holiday_requests/#{@request.id}/edit"
        flash "Successfull update."
      end
    end
  end

  def edit(params)
    HolidayRequest.find params[:id] do |request|
      @request = request
      renderEdit
    end
  end

  def new
    @request = self.class.klass.new({
      half_day: false
    })
    renderEdit
  end

  private

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

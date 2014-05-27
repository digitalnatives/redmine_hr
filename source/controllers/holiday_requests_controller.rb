require 'views/holiday_request/edit'

class HolidayRequestsController < ApplicationController

  route :new, :new

  resource HolidayRequest

  base Content

  def initialize
    super

    @base.on 'change' do
      input = @base.find('input[type=checkbox]')
      puts input.checked
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
        render 'views/holiday_request/edit', @request
      else
        puts "Done"
      end
    end
  end

  def new
    @request = self.class.klass.new({
      half_day: false
    })
    EmployeeProfile.all do |profiles|
      @request.data[:profiles] = profiles
      render 'views/holiday_request/edit', @request
    end
  end
end

require 'views/holiday_request/edit'

class HolidayRequestsController < ApplicationController

  route :new, :new

  resource HolidayRequest

  base Content

  def initialize
    super

    @base.on :submit do |e|
      e.stop
      submit
    end
  end

  def submit
    @request.update gather do
      puts @request.errors
    end
  end

  def new
    @request = self.class.klass.new({
      half_day: false
    })
    render 'views/holiday_request/edit', @request
  end
end

class HolidaysController < ApplicationController
  unloadable

  before_filter :authorize

  def authorize
    deny_access unless User.current.allowed_to?(:view_holidays,nil,global: true)
  end
end

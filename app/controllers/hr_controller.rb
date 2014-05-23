class HrController < ApplicationController
  unloadable

  before_filter :authorize

  def authorize
    deny_access unless User.current.allowed_to_hr?
  end
end

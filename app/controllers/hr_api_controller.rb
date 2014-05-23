class HrAPIController < ApplicationController
  unloadable

  before_filter :get_resource, :only => [:show,:update]

  rescue_from ActiveRecord::RecordNotFound do
    render :json => {message: 'Not Found!'}, :status => 404
  end

  rescue_from ActionController::UnpermittedParameters do
    render :json => {message: 'Unpermitted Parameters!'}, :status => 400
  end

  def index
    render :json => klass.all
  end

  def show
    render :json => @resource
  end

  def update
    @resource.update_attributes! safe_params
    show
  end

  private

  # We need to update override because
  # *.json is seen as Redmin API request
  def api_request?
    false
  end

  def get_resource
    @resource = klass.find(params[:id])
  end

  def klass
    controller_name.classify.constantize
  end

  def safe_params
    type = User.current.admin? ? :admin : :user
    attributes = self.class::UPDATEABLE_ATTRIBUTES[type]
    params.require(controller_name.classify.underscore).permit *attributes
  end
end

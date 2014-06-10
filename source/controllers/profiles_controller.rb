require 'views/employee_profile/index'
require 'views/employee_profile/show'
require 'views/employee_profile/edit'
require 'controllers/holiday_modifiers_controller'
require 'controllers/employee_children_controller'

class ProfilesController < ApplicationController
  route 'profiles/:id/modifiers', HolidayModifiersController
  route 'profiles/:id/employee_children', EmployeeChildrenController
  route 'profiles/:id/edit', :edit
  route 'profiles/:id', :show
  route 'profiles', :index

  route :index

  resource EmployeeProfile

  base Content

  def initialize
    super

    @base.delegate :click, 'button[name=cancel]' do |e|
      e.stop
      redirect "#profiles/#{@profile.id}"
    end

    @base.on :submit do |e|
      submit
      e.stop
    end
  end

  def submit
    return unless CurrentUser[:admin]
    return nil unless @profile
    @profile.update gather do
      redirect "profiles/#{@profile.id}"
    end
  end

  def edit(params)
    return unless CurrentUser[:admin]
    getProfile params[:id] do
      renderEdit
    end
  end

  def show(params)
    getProfile params[:id] do
      render 'views/employee_profile/show', @profile
    end
  end

  def index
    return redirect '#holiday_requests/mine' unless CurrentUser[:admin]
    EmployeeProfile.all do |profiles|
      render 'views/employee_profile/index', profiles: profiles
    end
  end

  private

  def renderEdit
    if CurrentUser[:admin]
      EmployeeProfile.all do |profiles|
        @profile.data[:supervisors] = profiles.map(&:user)
        render 'views/employee_profile/edit', @profile
      end
    else
      @profile.data[:supervisors] = [@profile.supervisor]
      render 'views/employee_profile/edit', @profile
    end
  end

  def getProfile(id, &block)
    EmployeeProfile.find id do |profile|
      @profile = profile
      block.call if block_given?
    end
  end
end

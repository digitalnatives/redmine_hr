require 'views/employee_profile/index'
require 'views/employee_profile/show'
require 'views/employee_profile/edit'
require 'controllers/holiday_modifiers_controller'
require 'controllers/employee_children_controller'

class ProfilesController < ApplicationController
  route 'profiles/:id/modifiers/:modifierId', HolidayModifiersController
  route 'profiles/:id/employee_children/:childId', EmployeeChildrenController
  route 'profiles/:id/edit', :edit
  route 'profiles/:id', :show
  route 'profiles', :index

  route :index

  resource EmployeeProfile

  base Content

  def initialize
    super

    @base.delegate :click, '[name=add_modifier]' do |e|
      e.stop
      addModifier
    end

    @base.delegate :click, '[name=add_child]' do |e|
      e.stop
      addChild
    end

    @base.on :submit do |e|
      submit
      e.stop
    end
  end

  def addModifier
    modifier = HolidayModifier.new({
      year: Time.now,
      value: @base.find('[name=value]').value,
      description: @base.find('[name=description]').value,
      hr_employee_profile_id: @profile.id
    })

    modifier.update do
      show id: @profile.id
    end
  end

  def addChild
    child = EmployeeChild.new({
      name: @base.find('[name=name]').value,
      birth_date: @base.find('[name=birth_date]').value,
      gender: @base.find('[name=gender]').value,
      hr_employee_profile_id: @profile.id
    })

    child.update do
      show id: @profile.id
    end
  end

  def submit
    return nil unless @profile
    @profile.update gather do
      redirect "profiles/#{@profile.id}"
    end
  end

  def edit(params)
    getProfile params[:id] do
      render 'views/employee_profile/edit', @profile
    end
  end

  def show(params)
    getProfile params[:id] do
      render 'views/employee_profile/show', @profile
    end
  end

  def index
    EmployeeProfile.all do |profiles|
      render 'views/employee_profile/index', profiles: profiles
    end
  end

  private

  def getProfile(id, &block)
    EmployeeProfile.find id do |profile|
      @profile = profile
      block.call if block_given?
    end
  end
end

require '../views/holiday_modifier/edit'

class HolidayModifiersController < ApplicationController
  route '/new',                 :new
  route '/:modifierId/delete',  :delete
  route '/:modifierId',         :edit

  resource HolidayModifier

  base Content

  def initialize
    super

    @base.delegate :click, 'button[name=cancel]' do |e|
      e.stop
      redirect "#profiles/#{@profile.id}"
    end

    @base.on :submit do |e|
      e.stop
      submit
    end
  end

  def submit
    return unless @holiday_modifier
    @holiday_modifier.update gather do
      if @holiday_modifier.errors
        render 'views/holiday_modifier/edit', @holiday_modifier.clone(gather)
      else
        redirect "profiles/#{@profile.id}"
      end
    end
  end

  def delete(params)
    getModifier params do
      @holiday_modifier.destroy do
        redirect "profiles/#{@profile.id}"
      end
    end
  end

  def edit(params)
    getModifier params do
      render 'views/holiday_modifier/edit', @holiday_modifier
    end
  end

  def new(params)
    @holiday_modifier = HolidayModifier.new({hr_employee_profile_id: params[:id]})
    @profile = EmployeeProfile.new({id: params[:id]})
    render 'views/holiday_modifier/edit', @holiday_modifier
  end

  private

  def getModifier(params,&block)
    EmployeeProfile.find params[:id] do |profile|
      @profile = profile
      @holiday_modifier = profile.holiday_modifiers.select do |mod|
        mod.id == params[:modifierId].to_i
      end.first
      block.call
    end
  end
end

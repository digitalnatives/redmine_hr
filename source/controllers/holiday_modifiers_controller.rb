require '../views/holiday_modifier/edit'

class HolidayModifiersController < ApplicationController
  route '/delete', :delete
  route :edit

  resource HolidayModifier

  base Content

  def initialize
    super

    @base.on :submit do |e|
      e.stop
      submit
    end
  end

  def submit
    return unless @holiday_modifier
    @holiday_modifier.update gather do
      redirect "profiles/#{@profile.id}"
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

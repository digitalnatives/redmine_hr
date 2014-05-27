require '../views/holiday_modifier/edit'

class HolidayModifiersController < ApplicationController
  route '/delete', :delete
  route :edit

  resource HolidayModifier

  base Content

  def initialize
    super
    @base.on :submit do |e| submit(e) end
  end

  def submit(e)
    e.stop
    return unless @modifier
    @modifier.update gather do
      redirect "profiles/#{@profile.id}"
    end
  end

  def delete(params)
    getModifier params do
      @modifier.destroy do
        redirect "profiles/#{@profile.id}"
      end
    end
  end

  def edit(params)
    getModifier params do
      render 'views/holiday_modifier/edit', @modifier
    end
  end

  private

  def getModifier(params,&block)
    EmployeeProfile.find params[:id] do |profile|
      @profile = profile
      @modifier = profile.holiday_modifiers.select do |mod|
        mod.id == params[:modifierId].to_i
      end.first
      block.call
    end
  end
end

require '../views/employee_child/edit'

class EmployeeChildrenController < ApplicationController
  route '/new',              :new
  route '/:childId/delete',  :delete
  route '/:childId',         :edit

  resource EmployeeChild

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
    return unless @employee_child
    @employee_child.update gather do
      if @employee_child.errors
        render 'views/employee_child/edit', @employee_child.clone(gather)
      else
        redirect "profiles/#{@profile.id}"
      end
    end
  end

  def delete(params)
    return unless CurrentUser.admin
    getChild params do
      @employee_child.destroy do
        redirect "profiles/#{@profile.id}"
      end
    end
  end

  def edit(params)
    return unless CurrentUser.admin
    getChild params do
      render 'views/employee_child/edit', @employee_child
    end
  end

  def new(params)
    return unless CurrentUser.admin
    @employee_child = EmployeeChild.new({hr_employee_profile_id: params[:id]})
    @profile = EmployeeProfile.new({id: params[:id]})
    render 'views/employee_child/edit', @employee_child
  end

  private

  def getChild(params,&block)
    EmployeeProfile.find params[:id] do |profile|
      @profile = profile
      @employee_child = profile.employee_children.find do |chd|
        chd.id == params[:childId].to_i
      end
      block.call
    end
  end
end

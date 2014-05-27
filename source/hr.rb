require 'fron'

require 'vendor/i18n'
require 'locales/en'

require './fron-ext/rails_adapter'
require './models/employee_profile.rb'

require './views/employee_profile/index'
require './views/employee_profile/show'
require './views/employee_profile/edit'
require './views/holiday_modifier/edit'

module Kernel
  def t(scope,options = {})
    `I18n.t(#{scope},JSON.parse(#{options.to_json}))`
  end
end

class MenuItem < Fron::Component
  tag 'li'

  component :a, 'a'

  delegate :text, :a

  def href=(value)
    @a['href'] = value
  end

  def href
    @a['href']
  end

end

items = {
  "#{t('hr.main_menu.employee_profiles')}" => "#profiles",
}

injectPoint = DOM::Element.new `document.querySelector("#main")`

main_menu = DOM::Document.find("#main-menu")
main_menu << (ul = DOM::Element.new 'ul')

items.each do |key,href|
  item = MenuItem.new
  item.text = key
  item.href = href
  ul << item
end

class Content < Fron::Component
  tag 'div#content'
end

class ApplicationController < Fron::Controller

  class << self
    attr_reader :klass

    def resource(value)
      @klass = value
    end
  end

  private

  def gather
    data = {}
    self.class.klass.fields.each do |field|
      el = @base.find("[name=#{field}]")
      next unless el
      value = case el.tag
      when 'input'
        if el['type'] == 'checkbox'
          el.checked
        else
          el.value
        end
      when 'textarea'
        el.value
      end
      data[field] = value
    end
    data
  end

  def render(template,data)
    @base.html = Template[template].render data
  end
end

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
      DOM::Window.hash = "profiles/#{@profile.id}"
    end
  end

  def delete(params)
    getModifier params do
      @modifier.destroy do
        DOM::Window.hash = "profiles/#{@profile.id}"
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

class ProfilesController < ApplicationController
  route 'profiles/:id/modifiers/:modifierId', HolidayModifiersController
  route 'profiles/:id/edit', :edit
  route 'profiles/:id', :show
  route 'profiles', :index

  route :index

  resource EmployeeProfile

  base Content

  def initialize
    super
    @base.delegate :click, 'button[name=add_modifier]' do |e|
      e.stop
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
    @base.on :submit do |e| submit(e) end
  end

  def submit(e)
    e.stop
    return unless @profile
    @profile.update gather do
      DOM::Window.hash = "profiles/#{@profile.id}"
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
      block.call
    end
  end
end

class RedmineHR < Fron::Application
  config.title = `document.title`
  config.stylesheets = []

  config.routes do
    map ProfilesController
  end

  config.customInject do |base|
    injectPoint.empty
    injectPoint << base
  end
end

RedmineHR.new


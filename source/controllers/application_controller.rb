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
      when 'select'
        el.value
      end
      data[field] = value
    end
    data
  end

  def empty
    @base.empty
  end

  def redirect(hash)
    DOM::Window.hash = hash
  end

  def render(template,data)
    @base.html = Template[template].render data
    %x{
      setTimeout(function(){
        if(!window.$) return
        $("[name*=date]").datepicker(datepickerOptions);
      })
    }
  end

  def flash(message)
    el = DOM::Element.new 'div'
    el.html = Template['views/flash'].render({message: message})
    @base.insertBefore el.children.first, @base.children.first
  end
end

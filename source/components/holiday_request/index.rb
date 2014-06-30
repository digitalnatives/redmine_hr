class HolidayRequestIndex < Fron::Component
  tag 'index'

  component :filters, HolidayRequestFilters
  component :content, 'div'

  delegate :gather,  :filters
  delegate :unscope, :filters

  def initialize
    super
    @loader = DOM::Element.new 'loader'
  end

  def loading=(value)
    if value
      @content.html = ''
      @content << @loader
    else
      @loader.remove
    end
  end

  def scope(user)
    @filters.scope user
  end
end

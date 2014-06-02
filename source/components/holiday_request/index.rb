class HolidayRequestIndex < Fron::Component
  tag 'index'

  component :filters, HolidayRequestFilters
  component :content, 'div'

  delegate :gather,  :filters
  delegate :unscope, :filters

  def scope(user)
    @filters.scope user
  end
end

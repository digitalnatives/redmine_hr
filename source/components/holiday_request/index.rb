class HolidayRequestIndex < Fron::Component
  tag 'index'

  component :filters, HolidayRequestFilters
  component :content, 'div'
  component :loader, 'loader'

  delegate :gather,  :filters
  delegate :unscope, :filters

  def scope(user)
    @filters.scope user
  end
end

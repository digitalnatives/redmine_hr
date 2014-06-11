module HrHolidayCalculator

  class << self
    attr_reader :modules

    def register_module(mod)
      @modules ||= {}
      @modules[mod.name] = mod
    end

    def calculate_duration(request)
      get_days(request)
    end

    def get_days(request)
      return 0.5 if request.half_day
      days = Secretary.ask(:interval, request.start_date, request.end_date)
      days.select{|date,value| value[:name] == Setting.plugin_redmine_hr[:working_day]}.count
    end

    def profile_info(profile, year, *without)
      holidays = profile.hr_holiday_requests.by_year(year) - without

      info = {
        holiday_count: holiday_count(profile,year) + sum_modifiers(profile,year),
        approved:      sum_holidays(holidays,:approved),
        requested:     sum_holidays(holidays, :requested),
        planned:       sum_holidays(holidays, :planned),
      }

      info[:unused] = [0,info[:holiday_count] - info[:approved] - info[:requested]].max
      info[:unused_planned] = [0,info[:unused] - info[:planned] ].max
      info
    end

    def holiday_count(profile,year)
      return 0 unless Setting.plugin_redmine_hr[:holiday_module]
      return 0 unless Setting.plugin_redmine_hr[:holiday_module][Date.today.year.to_s]
      (@modules[Setting.plugin_redmine_hr[:holiday_module][Date.today.year.to_s]] || @modules.values.first).calculate(profile,year)
    end

    private

    def sum_holidays(holidays,status)
      status = [status] unless status.is_a? Array
      holidays.select{ |h|
        status.map(&:to_sym).include?(h.status.to_sym)
      }.sum { |r| calculate_duration(r) }
    end

    def sum_modifiers(profile,year)
      modifiers = profile.hr_holiday_modifiers.by_year(year)
      modifiers.sum { |m| m.value }
    end
  end
end

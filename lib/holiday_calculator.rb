module HrHolidayCalculator

  class << self
    def calculate_duration(request)
      get_days(request).count
    end

    def get_days(request)
      days = Secretary.ask(:interval, request.start_date, request.end_date)
      days.select{|date,value| value[:name] == Setting.plugin_redmine_hr[:working_day]}
    end

    def profile_info(profile,year)
      holidays = profile.hr_holiday_requests.by_year(year)

      info = {
        holiday_count: holiday_count(profile,year) + sum_modifiers(profile,year),
        accepted:      sum_holidays(holidays,:accepted),
        requested:     sum_holidays(holidays, :requested),
        planned:       sum_holidays(holidays, :planned),
      }

      info[:unused] = [0,info[:holiday_count] - info[:accepted]].max
      info[:unused_planned] = [0,info[:holiday_count] - info[:accepted] - info[:planned]].max
      info
    end

    def holiday_count(profile,year)
      0
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

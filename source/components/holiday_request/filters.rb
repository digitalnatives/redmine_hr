require 'components/select'

class HolidayRequestFilters < Fron::Component
  tag 'filters'

  component :year,       Select, {text: t("hr.holiday_request.filters.year")}
  component :month,      Select, {text: t('hr.holiday_request.filters.month')}
  component :user,       Select, {text: t("hr.holiday_request.filters.user")}
  component :status,     Select, {text: t("hr.holiday_request.filters.status")}
  component :supervisor, Select, {text: t("hr.holiday_request.filters.supervisor")}
  component :button,     'button', {text: t("hr.holiday_request.filters.report")}

  on :click, 'button', :report
  on :change, '[name=year]', :toggleMonth

  def initialize
    super
    @year.select['name']       = 'year'
    @month.select['name']      = 'month'
    @user.select['name']       = 'user'
    @status.select['name']     = 'status'
    @supervisor.select['name'] = 'supervisor'
  end

  def toggleMonth
    if @year.value == ''
      @month.hide
      @month.value = ''
    else
      @month.style.display = 'inline-block'
    end
  end

  def report
    url = 'hr_holiday_requests/report.pdf?'+gather.to_query_string
    `window.open(#{url});`
  end

  def request
    @request ||= Fron::Request.new('hr_holiday_requests/filter_data')
  end

  def scope(user)
    @user.hide
    @supervisor.hide
    @user_id = user.id
  end

  def unscope
    @user.style.display = 'inline-block'
    @user_id = nil
    @supervisor.style.display = 'inline-block'
  end

  def gather
    {
      month: @month.value,
      year: @year.value,
      supervisor: @supervisor.value,
      status: @status.value,
      user: @user_id || @user.value
    }
  end

  def update(&block)
    params = {}
    params[:user] = @user_id if @user_id
    @supervisor.hide if !CurrentUser[:admin]
    request.get params do |response|

      @month.options  = response.json[:month].uniq.map { |month| [month,t("hr.months.#{month}")] }
      @year.options   = response.json[:year].uniq.map { |year| [year,year] }
      @status.options = response.json[:status].uniq.map do |status|
        [status,t("hr.holiday_request.statuses.#{status}")]
      end

      @user.options = response.json[:profiles]
      .map  { |p| [p[:id],"#{p[:user][:firstname]} #{p[:user][:lastname]}"] }
      .uniq { |u| u[0]   }

      @supervisor.options = response.json[:profiles]
      .map  { |p| p[:supervisor] }.compact
      .uniq { |u| u[:id]         }
      .map  { |u| [u[:id], "#{u[:firstname]} #{u[:lastname]}"] }

      toggleMonth
      block.call if block_given?
    end
  end
end

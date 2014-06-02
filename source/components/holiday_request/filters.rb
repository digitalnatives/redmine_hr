require 'components/select'

class HolidayRequestFilters < Fron::Component
  tag 'filters'

  component :year,       Select, {text: t("hr.holiday_request.filters.year")}
  component :user,       Select, {text: t("hr.holiday_request.filters.user")}
  component :status,     Select, {text: t("hr.holiday_request.filters.status")}
  component :supervisor, Select, {text: t("hr.holiday_request.filters.supervisor")}

  def initialize
    super
    @year.select['name']       = 'year'
    @user.select['name']       = 'user'
    @status.select['name']     = 'status'
    @supervisor.select['name'] = 'supervisor'
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
      year: @year.value,
      supervisor: @supervisor.value,
      status: @status.value,
      user: @user_id || @user.value
    }
  end

  def update(&block)
    params = {}
    params[:user] = @user_id if @user_id
    request.get params do |response|

      @year.options   = response.json[:year].map { |year| [year,year] }
      @status.options = response.json[:status].map do |status|
        [status,t("hr.holiday_request.statuses.#{status}")]
      end

      @user.options = response.json[:profiles]
      .map  { |p| [p[:id],"#{p[:user][:firstname]} #{p[:user][:lastname]}"] }
      .uniq { |u| u[0]   }

      @supervisor.options = response.json[:profiles]
      .map  { |p| p[:supervisor] }.compact
      .uniq { |u| u[:id]         }
      .map  { |u| [u[:id], "#{u[:firstname]} #{u[:lastname]}"] }

      block.call if block_given?
    end
  end
end

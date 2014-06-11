# encoding: utf-8
class HolidayReport < Prawn::Document
  def initialize(requests)
    super()
    @requests = requests

    @requests.group_by { |req| req[:user] }.each_with_index do |(user,requests), index|
      next if requests.length == 0
      start_new_page unless index == 0
      header
      create_table requests
    end
  end

  def header
    text I18n.t("hr.holiday_report.title", from_date: from_date, to_date: to_date), :size=> 20
    move_down 10
    line_width 0.2.mm
    stroke_color "999999"
    stroke_horizontal_rule
  end

  def create_table(requests)
    move_down 20
    table rows(requests) do
      cells.style size: 12, align: :center, border_color: "444444", border_width: 0.2.mm

      self.column_widths = [300,120,120]
      self.header        = true

      row(0).font_style  = :bold
      column(0).align    = :left
    end
  end

  def rows(requests)
    lines = [[
      I18n.t('hr.holiday_report.employee'),
      I18n.t('hr.holiday_report.date'),
      I18n.t('hr.holiday_report.type'),
    ]]

    requests.each_with_index do |request,index|
      lines << [request[:user],"",""] if index == 0
      req = HrHolidayRequest.new({
        start_date: request["start_date"],
        end_date: request["end_date"]
      })
      HrHolidayCalculator.get_days(req).each do |date,value|
        lines << [
          "",
          date,
          I18n.t("hr.holiday_request.#{request["request_type"]}")
        ]
      end
    end

    requests.group_by { |req| req["request_type"] }.each do |type,requests|
      count = requests.map { |req| req[:days] }.sum
      lines << [
        I18n.t('hr.holiday_report.sum', {type: I18n.t("hr.holiday_request.#{type}")}),
        "",
        I18n.t('hr.holiday_report.days', {days: count})
      ]
    end

    lines
  end

  private

  def from_date
    @requests.map { |req| req["start_date"]}.min
  end

  def to_date
    @requests.map { |req| req["end_date"]}.max
  end
end

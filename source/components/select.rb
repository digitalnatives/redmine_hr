class Select < Fron::Component
  tag 'select-field'

  attr_reader :options

  component :label, 'label'
  component :select, 'select'

  delegate :value, :select

  def text=(value)
    @label.text = "#{value}:"
  end

  def options=(data)
    @options = data
    @select.empty
    @select << DOM::Element.new("option[value=] "+t("hr.labels.all"))

    data.each do |value|
      @select << DOM::Element.new("option[value=#{value[0]}] #{value[1]}")
    end
  end
end

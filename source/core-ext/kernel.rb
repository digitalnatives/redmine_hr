module Kernel
  def t(scope,options = {})
    `I18n.t(#{scope},JSON.parse(#{options.to_json}))`
  end
end

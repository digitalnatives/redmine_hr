class MenuItem < Fron::Component
  tag 'li'

  component :a, 'a'

  delegate :text, :a

  def href=(value)
    @a['href'] = value
  end

  def href
    @a['href']
  end
end

class MainMenu
  def initialize(items)
    @base = DOM::Document.find("#main-menu")
    @base << (@ul = DOM::Element.new 'ul')

    items.each do |key,href|
      item = MenuItem.new
      item.text = key
      item.href = href
      @ul << item
    end
  end
end

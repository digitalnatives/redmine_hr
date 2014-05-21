require 'fron'

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

items = {
  'Test' => "#test",
  'Test All' => "#test-all"
}

main_menu = DOM::Document.find("#main-menu")
main_menu << (ul = DOM::Element.new 'ul')

items.each do |key,href|
  item = MenuItem.new
  item.text = key
  item.href = href
  ul << item
end

current_script = DOM::Element.new `document.currentScript`
current_script.parent << DOM::Text.new("HR Management")

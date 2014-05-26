When(/^I fill out the holiday modifier form$/) do
  page.find('[name=value]').set "0"
  page.find('[name=description]').set "description"
end

Then(/^I should see a holiday modifier item$/) do
  page.should have_css('td', text: '0')
  page.should have_css('td', text: 'description')
end

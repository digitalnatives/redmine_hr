When(/^I visit the new holiday modifier page$/) do
  visit "/hr#profiles/#{@user.id}/modifiers/new"
end

When(/^I fill out the holiday modifier form$/) do
	page.find('[name=year]').set "2014"
  page.find('[name=value]').set "0"
  page.find('[name=description]').set "description"
end

Then(/^I (should|should not) see a holiday modifier item$/) do |maybe|
  page.send maybe.gsub(/\s/,"_").to_sym, have_css('td', text: '0')
  page.send maybe.gsub(/\s/,"_").to_sym, have_css('td', text: 'description')
end

Given(/^The user has a holiday modifier$/) do
 	@modifier = @user.hr_employee_profile.hr_holiday_modifiers.create({year: Date.new(2014), value: 0, description: 'test'})
end

When(/^I delete the holiday modifier$/) do
  page.find('[href*=modifier]', text: I18n.t('hr.labels.delete')).click
end

When(/^I click on the edit link$/) do
  page.find('[href*=modifier]', text: I18n.t('hr.labels.edit')).click
end

Then(/^I should be on the edit holiday modifier page$/) do
	wait_for_hash "profiles/#{@user.id}/modifiers/#{@modifier.id}"
end

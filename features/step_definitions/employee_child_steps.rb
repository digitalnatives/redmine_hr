When(/^I fill out the employee child form$/) do
  page.find('[name=name]').set "Rafaelka"
  page.find('[name=birth_date]').set "2010-01-01"
  page.find('[name=gender]').set "male"
end

Then(/^I (should|should not) see an employee child item$/) do |maybe|
  page.send maybe.gsub(/\s/,"_").to_sym, have_css('td', text: 'Rafaelka')
  page.send maybe.gsub(/\s/,"_").to_sym, have_css('td', text: '2010-01-01')
end

Given(/^The user has a child$/) do
  @child = @user.hr_employee_profile.hr_employee_children.create({name: 'Rafaelka', birth_date: '2010-01-01', gender: "male"})
end

When(/^I delete the child$/) do
  page.find('[href*=child]', text: I18n.t('hr.labels.delete')).click
end

When(/^I click on the edit child link$/) do
  page.find('[href*=child]', text: I18n.t('hr.labels.edit')).click
end

Then(/^I should be on the edit child page$/) do
  wait_for_hash "profiles/#{@user.id}/employee_children/#{@child.id}"
end

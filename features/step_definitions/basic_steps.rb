Given(/^I am logged in$/) do
  User.current = User.create({firstname: 'Me', lastname: 'Me', admin: true})
end

Given(/^There is an?( administrator)? user$/) do |admin|
  @user = User.create({
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    admin: false
  })
  @user.hr_employee_profile.administrator = !!admin
  @user.hr_employee_profile.save!
end

When(/^I visit the employee profiles page$/) do
  visit "/hr#profiles"
end

Then(/^I should see (\d+) employee profile items$/) do |count|
  page.should have_css('tbody > tr', count: count.to_i)
end

When(/^I visit the employee profile page$/) do
  visit "/hr#profiles/#{@user.id}"
end

When(/^I visit the edit employee profile page$/) do
  visit "/hr#profiles/#{@user.id}/edit"
end

Then(/^I should see the profile$/) do
  page.should have_content "#{@user.lastname} #{@user.firstname}"
end

When(/^I click on the administrator checkbox$/) do
  page.find('input[type=checkbox]').click
end

When(/^I click on the save button$/) do
  page.find("button",text:I18n.t('hr.labels.save')).click
end

Then(/^I should be on the employee profile page$/) do
  wait_for_hash "profiles/#{@user.id}"
end

Then(/^The profile (should|should not) have administrator$/) do |maybe|
  @user.reload
  @user.hr_employee_profile.administrator.send maybe.gsub(/\s/,"_").to_sym, be_true
end

Given(/^I am logged in$/) do
  User.current = User.create({firstname: 'User', lastname: 'Test'})
end

Given(/^There is a user$/) do
	User.create({firstname: 'Test', lastname: 'User'})
end

When(/^I visit the employee profiles page$/) do
  visit "/hr#profiles"
end

Then(/^I should see (\d+) employee profile items$/) do |count|
  page.should have_css('tbody > tr', count: count.to_i)
end

When(/^I visit the employee profile page$/) do
  visit "/hr#profiles/1"
end

Then(/^I should see the profile$/) do
  page.should have_content "Test User"
end

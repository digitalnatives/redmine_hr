Given(/^I am logged in$/) do
  User.current = User.create({firstname: 'Me', lastname: 'Me', admin: true})
end

Given(/^There is a user$/) do
	@user = User.create({
		firstname: Faker::Name.first_name,
		lastname: Faker::Name.last_name,
		admin: false
	})
end

When(/^I visit the employee profiles page$/) do
  visit "/hr#profiles"
end

Then(/^I should see (\d+) employee profile items$/) do |count|
  page.should have_css('tbody > tr', count: count.to_i)
end

When(/^I visit the employee profile page$/) do
  visit "/hr#profiles/"+@user.id.to_s
end

Then(/^I should see the profile$/) do
  page.should have_content "#{@user.lastname} #{@user.firstname}"
end

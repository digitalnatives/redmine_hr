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

Then(/^I should see the profile?$/) do
  page.should have_content "#{@user.lastname} #{@user.firstname}"
end

Then(/^I should be on the employee profile page$/) do
  wait_for_hash "profiles/#{@user.id}"
end

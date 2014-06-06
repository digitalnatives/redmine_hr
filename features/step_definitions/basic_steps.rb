Given(/^I am logged in$/) do
  User.current = User.create({firstname: 'Me', lastname: 'Me'})
  User.current.test_role = :admin
end

Given(/^I am logged in as a normal user$/) do
  User.current = User.create({firstname: 'Me', lastname: 'Me'})
end

When(/^The administrator logges in$/) do
  User.current = @admin
end

Given(/^There is an?( administrator)? user$/) do |admin|
  @user = User.create({
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
  })
  @user.test_role = "admin" if !!admin
  @admin = @user if !!admin
  @user.save!
end

Given(/^It can't access the hr module$/) do
  @user.update_attributes(test_hr_access: false)
  @user.save!
end

When(/^I click on the (.+) button$/) do |name|
  page.find("button",text:I18n.t("hr.labels.#{name}")).click
end

Then(/^I should get (\d+) error messages?$/) do |amount|
  page.should have_css('#errorExplanation li', count: amount.to_i)
end

Then(/^I should see a success notification$/) do
  page.should have_css("#flash_notice")
end

Then(/^The (.+) field should have (\d+) options$/) do |field,num|
  page.should have_css("[name='#{field.gsub(/\s/,'_')}'] option", count: num.to_i)
end

When(/^I fill out the (.+) with "(.*?)"$/) do |field, value|
  page.find("[name='#{field.gsub(/\s/,'_')}']").set value
end

When(/^I (un)?check (.+)$/) do |neg,field|
  page.find("[name='#{field.gsub(/\s/,'_')}']").set neg == nil
end

Then(/^The (.+) should equal "(.*?)"$/) do |field, value|
  page.find("[name='#{field.gsub(/\s/,'_')}']").value.should eq value
end

Then(/^The (.+) (should|should not) be disabled$/) do |field,maybe|
  page.send maybe.gsub(/\s/,"_").to_sym, have_css("[name='#{field.gsub(/\s/,'_')}'][disabled]")
end

When(/^I filter for ([^\s]+) ([^\s]+)$/) do |value,field|
  select_option field, value
end

Then(/^I should not be able to filter for (.+)$/) do |field|
  page.should_not have_css("[name='#{field}']")
end

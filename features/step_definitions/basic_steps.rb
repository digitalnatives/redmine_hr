Given(/^I am logged in$/) do
  User.current = User.create({firstname: 'Me', lastname: 'Me', admin: true, view_holidays: true})
end

Given(/^There is an?( administrator)? user$/) do |admin|
  @user = User.create({
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    admin: false,
    view_holidays: true
  })
  @user.hr_employee_profile.administrator = !!admin
  @user.hr_employee_profile.save!
end

Given(/^It can't access the hr module$/) do
  @user.view_holidays = false
  @user.save
end

When(/^I click on the (.+) button$/) do |name|
  page.find("button",text:I18n.t("hr.labels.#{name}")).click
end

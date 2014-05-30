When(/^(I|The administrator) visits? the new holiday request page$/) do |who|
  visit "/hr#holiday_requests/new"
end

Then(/^I should be on the edit holiday request page$/) do
  wait_until { HrHolidayRequest.first }
  wait_for_hash "holiday_requests/#{HrHolidayRequest.first.id}/edit"
end

Given(/^I have a holiday request$/) do
  @request = User.first.hr_employee_profile.hr_holiday_requests.create({
    start_date: Date.today,
    end_date: Date.tomorrow,
    half_day: false
  })
end

When(/^(I|The administrator) visits? the holiday request page$/) do |who|
  page.visit "/hr#holiday_requests/#{@request.id}"
end

When(/^(I|The administrator) visits? the edit holiday request page$/) do |who|
  page.visit "/hr#holiday_requests/#{@request.id}/edit"
end

Then(/^I should be on the holiday request page$/) do
  wait_until { HrHolidayRequest.first }
  id = @request ? @request.id : HrHolidayRequest.first.id
  wait_for_hash "holiday_requests/#{id}"
end

Given(/^I have a (.+) holiday request$/) do |status|
  @request = User.current.hr_employee_profile.hr_holiday_requests.create({
    start_date: Date.tomorrow,
    end_date: Date.tomorrow,
    half_day: true,
    status: status
  })
end

Then(/^I (should|should not) be able to edit the holiday request$/) do |maybe|
  page.send maybe.gsub(/\s/,"_").to_sym, have_css('.contextual .icon.icon-edit')
end

Then(/^There should be (\d+) buttons$/) do |num|
  page.find("#content").should have_css('button', count: num.to_i)
end

Then(/^There should be a (.+) button$/) do |text|
  page.find("button", text: I18n.t("hr.holiday_request.transitions.#{text}"))
end

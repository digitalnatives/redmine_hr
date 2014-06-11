When(/^(I|The administrator) visits? the new holiday request page$/) do |who|
  visit "/hr#holiday_requests/new"
end

Then(/^I should be on the edit holiday request page$/) do
  wait_until { HrHolidayRequest.first }
  wait_for_hash "holiday_requests/#{HrHolidayRequest.first.id}/edit"
end

When(/^(I|The administrator) visits? the holiday request page$/) do |who|
  page.visit "/hr#holiday_requests/#{@request.id}"
end

When(/^(I|The administrator) visits? the edit holiday request page$/) do |who|
  page.visit "/hr#holiday_requests/#{@request.id}/edit"
end

Given(/^I visit the holiday requests page$/) do
  page.visit "/hr#holiday_requests/"
end

When(/^I visit the my holiday requests page$/) do
  page.visit "/hr#holiday_requests/mine"
end

Then(/^I should be on the holiday request page$/) do
  wait_until { HrHolidayRequest.first }
  id = @request ? @request.id : HrHolidayRequest.first.id
  wait_for_hash "holiday_requests/#{id}"
end

Given(/^(I|Someone) (?:have|has) an? (.+) holiday request( for last year)?$/) do |who,status,last_year|
  user = case who
  when "I"
    User.current
  when "Someone"
    u =User.create({firstname: 'Test', lastname: 'User'})
    u.hr_employee_profile.supervisor_id = User.current.id
    u.hr_employee_profile.save!
    u
  end
  @request = user.hr_employee_profile.hr_holiday_requests.new({
    half_day: true,
    status: status
  })
  if last_year
    @request.update_attributes({start_date: 1.year.ago, end_date: 1.year.ago})
  else
    @request.update_attributes({start_date: Date.tomorrow.to_time, end_date: Date.tomorrow.to_time})
  end
  @request.save
end

Then(/^I (should|should not) be able to edit the holiday request$/) do |maybe|
  page.send maybe.gsub(/\s/,"_").to_sym, have_css('.contextual .icon.icon-edit')
end

Then(/^I should see (\d+) holiday request items?$/) do |amount|
  page.should have_css('tbody tr.holiday-request-item', count: amount.to_i)
end

Then(/^There should be (\d+) buttons$/) do |num|
  page.find("#content").should have_css('button', count: num.to_i)
end

Then(/^There should be a (.+) button$/) do |text|
  page.should have_css("button", text: I18n.t("hr.holiday_request.transitions.#{text}"))
end

When(/^I filter for the current year$/) do
  select_option('year',Date.today.year)
end

When(/^I filter for myself$/) do
  select_option('user',User.current.hr_employee_profile.id)
end

When(/^I filter for myself as supervisor$/) do
  select_option('supervisor',User.current.id)
end

When(/^I click on the (.+) action$/) do |action|
  page.find("a[action='#{action}']").click
end

Then(/^There should be a (.+) action$/) do |action|
  page.should have_css("a[action='#{action}']")
end

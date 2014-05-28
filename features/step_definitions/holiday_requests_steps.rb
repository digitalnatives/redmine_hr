When(/^I visit the new holiday request page$/) do
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

When(/^I visit the edit holiday request page$/) do
  page.visit "/hr#holiday_requests/#{@request.id}/edit"
end

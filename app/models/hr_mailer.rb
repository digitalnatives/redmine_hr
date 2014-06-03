class HrMailer < ActionMailer::Base
  layout 'mailer'

  def requested(request)
    @request = request

    profile = request.hr_employee_profile

    recipients = []
    recipients << profile.supervisor.mail if profile && profile.supervisor
    recipients = recipients + User.all.to_a.select { |user| user.role == :admin }.map(&:mail)

    mail :to => recipients,
         :subject => "Holiday Request for #{request.hr_employee_profile.user.name}"
  end
end

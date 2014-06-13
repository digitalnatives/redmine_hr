class HrMailer < Mailer
  layout 'hr_mailer'

  def self.default_url_options
    { :host => Setting.host_name, :protocol => Setting.protocol }
  end

  def requested(request)
    @request = request

    mail :to => get_admins(request),
         :subject => I18n.t('hr_mailer.requested.subject', user: request.hr_employee_profile.user.name)
  end

  def withdrawn(request)
    @request = request

     mail :to => get_admins(request),
         :subject => I18n.t('hr_mailer.withdrawn.subject', user: request.hr_employee_profile.user.name)
  end

  def approved(request)
    @request = request

    mail :to => request.hr_employee_profile.user.mail,
         :subject => I18n.t('hr_mailer.approved.subject')
  end

  def approved_withdrawn(request)
    @request = request

    mail :to => request.hr_employee_profile.user.mail,
         :subject => I18n.t('hr_mailer.approved_withdrawn.subject')
  end

  def rejected(request)
    @request = request

    mail :to => request.hr_employee_profile.user.mail,
         :subject => I18n.t('hr_mailer.rejected.subject')
  end

  def rejected_withdrawn(request)
    @request = request

    mail :to => request.hr_employee_profile.user.mail,
         :subject => I18n.t('hr_mailer.rejected_withdrawn.subject')
  end

  private

  def get_admins(request)
    profile = request.hr_employee_profile

    admins = []
    admins << profile.supervisor.mail if profile && profile.supervisor
    admins = admins + User.all.to_a.select { |user| user.role == :admin }.map(&:mail)
    admins
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)

    can [:create,:show], HrHolidayRequest

    can :update, HrHolidayRequest do |request|
      profile = request.hr_employee_profile

      user.role == :admin        ||
      profile.supervisor == user ||
      (profile.user == user && ['requested','planned'].include?(request.status))
    end

    can [:approve, :reject, :approve_withdrawn, :reject_withdrawn], HrHolidayRequest do |request|
      profile = request.hr_employee_profile

      user.role == :admin || profile.supervisor == user
    end

    can [:withdraw,:request,:cancel,:remove], HrHolidayRequest do |request|
      profile = request.hr_employee_profile

      user.role == :admin        ||
      profile.supervisor == user ||
      profile.user == user
    end
  end
end

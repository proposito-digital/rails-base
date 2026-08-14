class DashboardPolicy < ApplicationPolicy
  def menu?
    user.present?
  end

  def index?
    user.present?
  end
end

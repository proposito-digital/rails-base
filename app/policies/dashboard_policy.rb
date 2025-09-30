class DashboardPolicy < ApplicationPolicy
  def menu?
    true
  end
  def index?
    true
  end
end

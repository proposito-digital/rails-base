# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  skip_before_action :set_model_class

  def index
    authorize :dashboard, :index?
    skip_policy_scope
    @users_count = User.count
    @dogs_count = Dog.count
    @readme = File.read("#{Rails.root}/README.md")
    render "dashboard"
  end
end

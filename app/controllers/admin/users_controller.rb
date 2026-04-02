# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  private

  def default_params_permited
    [ :email_address, :password, :password_confirmation ]
  end

  def filter_fields
    [ "users.name" ]
  end

  def instance_params
    safe_params = super

    return safe_params.except(:password, :password_confirmation) if safe_params[:password].blank?

    safe_params
  end
end

# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  private

  def default_params_permited
      [ :email_address, :password, :password_confirmation ]
  end

  def filter_fields
      [ "users.name" ]
  end
end

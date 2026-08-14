# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  def destroy
    if @instance == Current.user
      return prevent_self_deactivation
    end

    @instance.sessions.destroy_all
    @instance.update!(deleted_at: Time.current)

    respond_to do |format|
      format.html { redirect_to send(redirect_to_index), flash: { success: translate_flash("success") } }
      format.json { head :no_content }
    end
  end

  private

  def default_params_permited
    [ :email_address, :password, :password_confirmation ]
  end

  def filter_fields
    [ "users.email_address" ]
  end

  def sort_fields
    [ "users.email_address" ]
  end

  def instance_params
    safe_params = super

    return safe_params.except(:password, :password_confirmation) if safe_params[:password].blank?

    safe_params
  end

  def prevent_self_deactivation
    respond_to do |format|
      format.html do
        redirect_to send(redirect_to_index), alert: t("authentication.users.cannot_deactivate_self")
      end
      format.json do
        render json: { error: t("authentication.users.cannot_deactivate_self") }, status: :unprocessable_entity
      end
    end
  end
end

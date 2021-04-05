# frozen_string_literal: true

# Controller to customize the Devise registration flow
class Users::RegistrationsController < Sunrise::Controllers::Registrations
  helper_method :registration_mutation
  include Users::Helpers
  before_action :save_modal_path_after_login

  def create
    return unless recaptcha_valid?

    outcome = registration_mutation.process_with_params(params)
    if outcome.success?
      sign_in(:user, outcome.result)

      if after_login_or_signup_path
        redirect_to after_login_or_signup_path+'?new_user', turbolinks: false
      else
        full_page_redirect_to user_path+'?new_user'
      end
    else
      render :new
    end
  end

  private

  def registration_mutation
    @registration_mutation ||= Forms::CreateUser.new
  end
end

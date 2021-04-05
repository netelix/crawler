# frozen_string_literal: true

# Log in and log out
class Users::SessionsController < Sunrise::Controllers::Sessions
  include Users::Helpers
  before_action :save_modal_path_after_login

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?

    if after_login_or_signup_path
      redirect_to after_login_or_signup_path, turbolinks: false
    else
      full_page_redirect_to user_path
    end
  end
end

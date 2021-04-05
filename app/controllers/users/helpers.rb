module Users
  module Helpers
    extend ActiveSupport::Concern

    def after_login_or_signup_path
      return root_path

      session[:modal_path_after_login]
    end

    def save_modal_path_after_login
      return unless params[:modal_path_after_login]

      session[:modal_path_after_login] = params[:modal_path_after_login]
    end
  end
end

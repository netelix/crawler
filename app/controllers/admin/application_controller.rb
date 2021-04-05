# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    layout "admin"
    before_action :authenticate_admin

    def authenticate_admin
      if (!current_user.present?) || (!current_user.admin?)
        redirect_to root_path
      end
    end

    def index

    end
  end
end

class Admin::ApplicationController < ApplicationController
   # before_action :authenticate_admin!

    private

    def authenticate_admin!
      unless Current.user
        redirect_to root_path, alert: "You must be logged in."
      end
    end

    def authorize_any_role!
      unless Current.user.roles.exists?
        redirect_to '/unauthorized'
      end
    end

    def authorize_admin!
      unless Current.user.roles.exists?(name: 'admin')
        redirect_to '/unauthorized'
      end
    end

    def authorize_permission!(permission)
      return if Current.user.roles.exists?(name: 'admin')

      unless Current.user.has_permission?(permission)
        redirect_to root_path, alert: "You are not authorized to perform this action."
      end
    end
end

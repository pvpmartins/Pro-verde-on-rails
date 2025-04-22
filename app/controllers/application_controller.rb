class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  inertia_share do {
    current_user: { id: Current&.session&.user&.id, 
    email: Current&.session&.user&.email_address, 
    first_name: Current&.session&.user&.first_name,
    last_name: Current&.session&.user&.last_name,
    }
  }
  end
end

class Admin::UsersController < Admin::ApplicationController
  def index
    users = User.select(
      :id, 
      :first_name,
      :last_name,
      :email_address,
      :role_id,
    )
    render inertia: 'Admin/Users/Index', props: { users: users }
  end
end

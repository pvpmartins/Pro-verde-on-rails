class Admin::UsersController < Admin::ApplicationController
  def index
    users = User.all
    render inertia: 'Admin/Users/Index', props: { users: users }
  end
end

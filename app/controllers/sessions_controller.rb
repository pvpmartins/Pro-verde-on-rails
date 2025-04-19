class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    render inertia: 'Sessions/Login'
  end

  def create
    puts "PARAMS #{params}"
    if user = User.authenticate_by(session_params)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def session_params
    params.require(:session).permit(:email_address, :password)
  end
end

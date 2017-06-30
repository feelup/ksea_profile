class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def list_of_events
  	@user = current_user
    @has_access_to=Attendance.where(user_id:@user.id).pluck(:event_id)
    @events=Event.where(id: @has_access_to).order(id: :desc)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end

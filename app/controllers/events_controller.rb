class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
  end
  def show
    if current_user.admin? || current_user.profiles.count(:id) > 0
      @event = Event.find(params[:id])
      @users=@event.users.pluck(:id)
      @profiles=Profile.where(user_id: @users).order(:first_name).search(params[:search_school_company],params[:search_location]).page(params[:page]).per(24)
    else
      redirect_to(new_profile_path)
    end
    list_of_events
    if !@has_access_to.include?(@event.id)
      redirect_to root_path
    end
    
  end
  def latest
  	@event = current_user.events.last
    if @event.nil?
      redirect_to new_attendance_path
    else
      redirect_to(event_path(@event))
    end
  end
end

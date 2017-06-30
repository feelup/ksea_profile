class AttendancesController < ApplicationController
  before_action :authenticate_user!
	def new
    @user = current_user
    @has_access_to=Attendance.where(user_id:@user.id).pluck(:event_id)
    @events=Event.where.not(id: @has_access_to).order(id: :desc)
    if (@events.nil?)
      redirect_to root_path
    end
    @attendance = Attendance.new
  end
  def create
    @event = Event.find(params[:attendance][:event_id])
    if @event.password==params[:password]
      @attendance = Attendance.new(attendance_params)
      if @attendance.save
        flash[:notice] = "Successfully added to an event."
      end
    else
      flash[:error] = "Wrong Passcode. Try again."
      redirect_to new_attendance_path and return
    end
    redirect_to root_path
	end
  private
    def attendance_params
      params.require(:attendance).permit(:event_id, :user_id)
    end
end

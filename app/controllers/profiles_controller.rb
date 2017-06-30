class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def autocomplete_profile_country
    render json: json_for_autocomplete(Profile.select(:country).distinct.where('LOWER(profiles.country) ILIKE ?', "%#{params[:term]}%"), :country)
  end
  def autocomplete_profile_city
    render json: json_for_autocomplete(Profile.select(:city).distinct.where('LOWER(profiles.city) ILIKE ?', "%#{params[:term]}%"), :city)
  end
  def autocomplete_education_name
    render json: json_for_autocomplete(Education.select(:name).distinct.where('LOWER(educations.name) ILIKE ?', "%#{params[:term]}%"), :name)
  end
  def autocomplete_education_major
    render json: json_for_autocomplete(Education.select(:major).distinct.where('LOWER(educations.major) ILIKE ?', "%#{params[:term]}%"), :major)
  end
  def autocomplete_experience_company_name
    render json: json_for_autocomplete(Experience.select(:company_name).distinct.where('LOWER(experiences.company_name) ILIKE ?', "%#{params[:term]}%"), :company_name)
  end
  def autocomplete_experience_title
    render json: json_for_autocomplete(Experience.select(:title).distinct.where('LOWER(experiences.title) ILIKE ?', "%#{params[:term]}%"), :title)
  end

	def index
    if current_user.admin? || current_user.profiles.count(:id) > 0
      @profiles=Profile.order(:first_name).search(params[:search_school_company],params[:search_location]).page(params[:page]).per(24)
    else
      redirect_to(new_profile_path)
    end
    list_of_events
  end

  def show
    list_of_events
    @profile = Profile.find(params[:id])
  end

  def new
    list_of_events
    if current_user.admin? || current_user.profiles.count(:id) == 0
      @profile = Profile.new
      @profile.educations.build
      @profile.experiences.build
    else
      redirect_to(edit_profile_path(current_user.profiles.first))
    end
	end

	def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    if @profile.save
      flash[:notice] = "Successfully created profile."
    else
      redirect_to @profile and return
    end
    redirect_to root_path
	end

  def edit
    list_of_events
    @profile = Profile.find(params[:id])
    unless current_user == @profile.user || current_user.admin?
      redirect_to(event_profile_path)
    end
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update_attributes(profile_params)
    if @profile.update(profile_params)
      redirect_to(event_profile_path(@event.id,@profile.id))
    else
      render :action => 'edit'
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    flash[:notice] = "Successfully destroyed profile."
    redirect_to profiles_path
  end

  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :email, :phone, :country, :city, :state, :linkedin_url, :facebook_url, :image, :affiliation, :title, educations_attributes: [:id, :school_type, :name, :end_year, :major, :_destroy], experiences_attributes: [:id, :job_type, :company_name, :title, :country, :city, :start_month, :start_year, :end_month, :end_year, :is_present, :industry, :_destroy])
    end
end
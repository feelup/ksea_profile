class Profile < ActiveRecord::Base
	has_many :educations, :dependent => :destroy
	accepts_nested_attributes_for :educations, :allow_destroy => true

	has_many :experiences, :dependent => :destroy
	accepts_nested_attributes_for :experiences, :allow_destroy => true

	belongs_to :user

  mount_uploader :image, ImageUploader

	def self.search(search_school_company,search_location)
    if (search_school_company.present? && search_location.present?)
      joins('LEFT OUTER JOIN educations ON educations.profile_id = profiles.id LEFT OUTER JOIN experiences ON experiences.profile_id = profiles.id').where('(lower(educations.name) LIKE ? OR lower(experiences.company_name) LIKE ? OR lower(profiles.first_name) LIKE ? OR lower(profiles.last_name) LIKE ?) AND (lower(profiles.city) LIKE ? OR lower(profiles.state) LIKE ? OR lower(profiles.country) LIKE ?)', "%#{search_school_company}%".downcase, "%#{search_school_company}%".downcase, "%#{search_school_company}%".downcase, "%#{search_school_company}%".downcase, "%#{search_location}%".downcase,"%#{search_location}%".downcase,"%#{search_location}%".downcase).group("profiles.id")
    elsif (search_school_company.present? && search_location.blank?)
    	joins('LEFT OUTER JOIN educations ON educations.profile_id = profiles.id LEFT OUTER JOIN experiences ON experiences.profile_id = profiles.id').where('lower(educations.name) LIKE ? OR lower(experiences.company_name) LIKE ? OR lower(profiles.first_name) LIKE ? OR lower(profiles.last_name) LIKE ?', "%#{search_school_company}%".downcase, "%#{search_school_company}%".downcase, "%#{search_school_company}%".downcase, "%#{search_school_company}%".downcase).group('profiles.id')
    elsif (search_school_company.blank? && search_location.present?)
    	order(:first_name).joins('LEFT OUTER JOIN educations ON educations.profile_id = profiles.id LEFT OUTER JOIN experiences ON experiences.profile_id = profiles.id').where('lower(profiles.city) LIKE ? OR lower(profiles.state) LIKE ? OR lower(profiles.country) LIKE ?', "%#{search_location}%".downcase, "%#{search_location}%".downcase, "%#{search_location}%".downcase).group("profiles.id")
    else
      all
    end
  end
end
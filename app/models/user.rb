class User < ActiveRecord::Base
	has_many :profiles, :dependent => :destroy
	has_many :attendances
  has_many :events, :through => :attendances
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

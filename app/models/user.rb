class User < ActiveRecord::Base
  # Attributes :access_token, :binx_id, :additional_emails, :admin
  #            :email_confirmation_token, :binx_bike_ids
  # 
  # 
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:bike_index]

  validates_presence_of :binx_id
  validates_uniqueness_of :binx_id
  serialize :additional_emails
  serialize :binx_bike_ids
  has_many :incidents

  def self.from_omniauth(auth)
    where(binx_id: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.binx_id = auth.uid
      user.access_token = auth.uid
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.bike_index_data"] && session["devise.bike_index_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end

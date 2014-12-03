class User < ActiveRecord::Base
  # Attributes :binx_id, :admin, :email, :email_confirmation_token
  #            :binx_bike_ids, :name, :legacy_bw_id
  #            :experience_level_select_id, :birth_year, :gender_select_id
  # 
  # 
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:bike_index]

  # validates_presence_of :binx_id
  # validates_uniqueness_of :binx_id
  validates_uniqueness_of :binx_id, :allow_blank => true, :allow_nil => true
  serialize :binx_bike_ids
  serialize :legacy_bw_hash
  has_many :incidents

  belongs_to :experience_level_select, class_name: "Selection"
  belongs_to :gender_select, class_name: "Selection"

  def display_id
    [name, email].compact.first
  end

  def self.from_omniauth(auth)
    user = where(binx_id: auth.uid).first
    return user if user.present?
    e = auth.info.email
    user = User.where(email: e).first || User.new(email: e)
    user.update_attributes(binx_id: auth.uid,
      name: auth.info.name,
      binx_bike_ids: auth.info.bike_ids,
      password: Devise.friendly_token[0,20]
    )
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.bike_index_data"] && session["devise.bike_index_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_or_new_from_legacy_hash(h)
    hash = ActiveSupport::HashWithIndifferentAccess.new(h)
    email = hash[:verified_email] || hash[:email]
    u = User.where(email: email).first
    u = User.new(email: email) unless u.present?
    u.attributes = {
      password: Devise.friendly_token[0,20],
      legacy_bw_id: hash[:id].to_i,
      legacy_bw_hash: hash,
      email: email,
      name: hash[:person_name], 
      birth_year: hash[:year_of_birth].to_i
    }
    g = hash[:gender]
    if g.present?
      g_name = g.match(/m/i) ? 'male' : 'female'
      gs = Selection.find_or_create_by(select_type: 'gender', name: g_name, user_created: false)
      u.gender_select_id = gs.id
    end
    u.save
    u.update_attribute :created_at, Time.parse(hash[:register_date]) if hash[:register_date].present?
    u
  end

end

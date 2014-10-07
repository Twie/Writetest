require 'date'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  TEMP_EMAIL_PREFIX = 'change@me'
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable
  validates_uniqueness_of :username
  validates_presence_of :firstname, :lastname, :username
  has_many :user_groups, :dependent => :destroy
  has_many :groups, through: :user_groups
  has_many :sentences
  has_many :identities, :dependent => :destroy
  
  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      if(auth.provider == 'google_oauth2')
        email_is_verified = auth.info.email && auth.extra.raw_info.email_verified
      end
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      if user.nil?
          user = self.generate_user_from_omniauth(auth, email)  
        user.save!
      end
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
  
  def self.generate_user_from_omniauth(auth, email)
      user = User.new(firstname: auth.info.first_name, lastname: auth.info.last_name, username: generate_unique_username(auth.info.name),
        email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
        password: Devise.friendly_token[0,20],
      )
  end
  
  private # all methods that follow will be made private: not accessible for outside objects
  def self.generate_unique_username(name)
    username = name.gsub(/\s+/, "")
    if User.find_by_username(username).present? 
      timestamp = DateTime.now.strftime('%Q').to_s
      timestamp_len = timestamp.length
      username = username + timestamp[timestamp_len-4..timestamp_len]
    end
    username
  end
end

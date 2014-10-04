class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
  validates_uniqueness_of :username
  validates_presence_of :firstname, :lastname, :username
  has_many :user_groups, :dependent => :destroy
  has_many :groups, through: :user_groups
  has_many :sentences
end

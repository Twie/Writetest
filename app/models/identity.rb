class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  def self.find_for_oauth(auth)
    provider = auth.provider.try(:to_s)
    provider = "facebook" if provider == "facebook_invite"
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end

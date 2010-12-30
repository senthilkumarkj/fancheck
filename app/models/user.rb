class User < ActiveRecord::Base
  has_many :fan_checks

  validates_presence_of :twitter_id, :oauth_token, :oauth_token_secret
end

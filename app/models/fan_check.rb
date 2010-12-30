class FanCheck < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'twitter_id'

  validates_presence_of :twitter_id, :user_a, :user_b

  #attr_accessor :valid_a,:valid_b,:protected_a,:protected_b,:a_fan_of_b,:b_fan_of_a,:state,:a_b_friends
  
  def do_fan_check
    begin
      twttr_user_a = validate_twitter_user(true)
      twttr_user_b = validate_twitter_user(false)
      if self.valid_a && self.valid_b
        self.protected_a = twttr_user_a.protected
        self.protected_b = twttr_user_b.protected
        if !self.protected_a && !self.protected_b
          friends_of_a = get_friends(true)
          friends_of_b = get_friends(false)
          self.followers_count_a = friends_of_a.size
          self.followers_count_b = friends_of_b.size
          p friends_of_a
          p friends_of_b
          self.a_fan_of_b = friends_of_a.include?(self.user_b_id.to_i)
          self.b_fan_of_a = friends_of_b.include?(self.user_a_id.to_i)
          self.a_b_friends = self.a_fan_of_b && self.b_fan_of_a
          self.state = 4
        elsif !self.protected_a && self.protected_b
          friends_of_a = get_friends(true)
          self.followers_count_a = friends_of_a.size
          self.a_fan_of_b = friends_of_a.include?(self.user_b_id.to_i)
          self.state = 3
        elsif self.protected_a && !self.protected_b
          friends_of_b = get_friends(false)
          self.followers_count_b = friends_of_b.size
          self.b_fan_of_a = friends_of_b.include?(self.user_a_id.to_i)
          self.state = 2
        else
          #error msg
          self.state = 1
        end
      else
         #error msg
         self.state = 0
      end
      self.checked_at = Time.now
      self.state
    rescue Exception => e
      p e
      self.state = -1
    end
  end

  def get_result_text
    case self.state
     when 0 #invalid id(s)
      if self.valid_a
        "We tracked #{get_twitter_link(self.user_a)} but #{get_twitter_link(self.user_b)} eludes us. Typo?"
      elsif self.valid_b
        "We tracked #{get_twitter_link(self.user_b)} but #{get_twitter_link(self.user_a)} eludes us. Typo?"
      else
        "#{get_twitter_link(self.user_a)} and #{get_twitter_link(self.user_b)} don't seem to be valid twitter users."
      end
     when 1 #both are protected ids
        "Both #{get_twitter_link(self.user_a)} and #{get_twitter_link(self.user_b)} have protected their accounts. Under cover agents?"
     when 2 #user_a is protected
        res = self.b_fan_of_a ? "#{get_twitter_link(self.user_b)} is a fan of #{get_twitter_link(self.user_a)}" : "#{get_twitter_link(self.user_b)} is not a fan of #{get_twitter_link(self.user_a)}."
        #res += "How about that? #{self.user_a}" if !self.b_fan_of_a && self.verified_a
        #res+= " #{self.user_a} has protected his/her account"
        res
     when 3 #user_b is protected
        res = self.a_fan_of_b ? "#{get_twitter_link(self.user_a)} is a fan of #{get_twitter_link(self.user_b)}" : "#{get_twitter_link(self.user_a)} is not a fan of #{get_twitter_link(self.user_b)}." 
        #res+= " #{self.user_b} has protected his/her account"
        res
     when 4 #both are public
         if self.verified_a && self.verified_b
           res = self.b_fan_of_a ? "#{get_twitter_link(self.user_b)} is a fan of #{get_twitter_link(self.user_a)}" : " #{get_twitter_link(self.user_b)} is not a fan of #{get_twitter_link(self.user_a)}. WHOA!"
           res = self.a_fan_of_b ? "#{get_twitter_link(self.user_a)} is a fan of #{get_twitter_link(self.user_b)}" : " #{get_twitter_link(self.user_a)} is not a fan of #{get_twitter_link(self.user_b)}. WHOA!"
           res = "Hello everybody! We've got fan celebrities. They are fan of each other!!! #{get_twitter_link(self.user_a)} #{get_twitter_link(self.user_b)}" if self.a_fan_of_b && self.b_fan_of_a
           if !self.a_fan_of_b && !self.user_b_of_a
             res = "Perhaps #{get_twitter_link(self.user_a)} and #{get_twitter_link(self.user_b)} haven't heard of each other. But how come?? It's " + self.followers_count_a > self.followers_count_b ? get_twitter_link(self.user_a) : get_twitter_link(self.user_b)
           end
         elsif self.verified_a || self.verified_b
           res = self.b_fan_of_a ? "#{get_twitter_link(self.user_b)} is a fan of #{get_twitter_link(self.user_a)}" : " #{get_twitter_link(self.user_b)} is not a fan of #{get_twitter_link(self.user_a)}"
           res = self.a_fan_of_b ? "#{get_twitter_link(self.user_a)} is a fan of #{get_twitter_link(self.user_b)}" : " #{get_twitter_link(self.user_a)} is not a fan of #{get_twitter_link(self.user_b)}"
           if self.a_fan_of_b && self.b_fan_of_a
             res = "#{get_twitter_link(self.user_a)} and #{get_twitter_link(self.user_b)} are fan of each other! Perhaps " + (self.verified_a ? get_twitter_link(self.user_b) : get_twitter_link(self.user_a)) + " should get verified by Twitter eh?"
           elsif !self.a_fan_of_b && !self.b_fan_of_a
            res = "#{get_twitter_link(self.user_a)} is not a fan of #{get_twitter_link(self.user_b)}. #{get_twitter_link(self.user_b)} doesn't follow #{get_twitter_link(self.user_a)} either!" if self.verified_a?
            res = "#{get_twitter_link(self.user_b)} is not a fan of #{get_twitter_link(self.user_a)}. #{get_twitter_link(self.user_a)} doesn't follow #{get_twitter_link(self.user_b)} either!" if self.verified_b?
           end
         else
           res = self.b_fan_of_a ? "#{get_twitter_link(self.user_b)} is a fan of #{get_twitter_link(self.user_a)}" : " #{get_twitter_link(self.user_b)} is not a fan of #{get_twitter_link(self.user_a)}. Celebrity Alert!!"
           res = self.a_fan_of_b ? "#{get_twitter_link(self.user_a)} is a fan of #{get_twitter_link(self.user_b)}" : " #{get_twitter_link(self.user_a)} is not a fan of #{get_twitter_link(self.user_b)}. Celebrity Alert!!"
           res = "#{get_twitter_link(self.user_a)} and #{get_twitter_link(self.user_b)} are friends! They are fan of each other!" if self.a_fan_of_b && self.b_fan_of_a
           if !self.a_fan_of_b && !self.b_fan_of_a
             res = "What we have got is two strangers!! #{get_twitter_link(self.user_a)} and #{get_twitter_link(self.user_b)} do not follow each other!"
           end
         end
         res
     else
        "some error has happened"
    end
  end

  private

  def validate_twitter_user(is_user_a)
    begin
      if is_user_a
        user_a = Twitter.user(self.user_a.downcase)
        self.valid_a = 1
        self.user_a_id = user_a.id_str
        self.user_a_dp = user_a.profile_image_url
        self.verified_a = user_a.verified
      else
        user_b = Twitter.user(self.user_b.downcase)
        self.valid_b = 1
        self.user_b_id = user_b.id_str
        self.user_b_dp = user_b.profile_image_url
        self.verified_b = user_b.verified
      end
    rescue
      is_user_a ? self.valid_a = 0 : self.valid_b = 0
    end
    is_user_a ? user_a : user_b
  end

  def get_friends(is_user_a)
    is_user_a ? Twitter.friend_ids(:screen_name => "#{self.user_a}").ids : Twitter.friend_ids(:screen_name => "#{self.user_b}").ids
  end
  
  def get_twitter_link(screen_name)
    "<a href = \"#{TWITTER_PROFILE_LINK_BASE}#{screen_name}\">@#{screen_name}</a>"
  end
end

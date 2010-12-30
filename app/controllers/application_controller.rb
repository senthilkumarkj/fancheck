class ApplicationController < ActionController::Base
  protect_from_forgery
  def index
    @user_a, @user_b= '', ''
    if !params.nil? && params.size >= 2 && (!params[:u1].blank? && !params[:u2].blank?)
      @fan_checked = false
      @user_a = params[:u1].downcase
      @user_b = params[:u2].downcase
      fc = FanCheck.new(:twitter_id => GUEST_TWTTR_ID,:user_a => @user_a,:user_b => @user_b)
      fc.do_fan_check
      fc.save
      @result_text = fc.get_result_text.html_safe
      @fan_checked = true
      @user_a = params[:u1]
      @user_b = params[:u2]
    else
    @fan_checked = false;
    #just show form with two input boxes
    end
  end
end

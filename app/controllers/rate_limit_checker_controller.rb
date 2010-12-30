class RateLimitCheckerController < ApplicationController
  def index
    client = Twitter::Client.new
    rate_limit_status = client.rate_limit_status
    remaining_hits = rate_limit_status.remaining_hits
    @online_status = remaining_hits >= MIN_TWTTR_REQ_PER_FANCHECK
    render :layout => false
  end
end

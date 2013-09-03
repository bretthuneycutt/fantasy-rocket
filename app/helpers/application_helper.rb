module ApplicationHelper
  def league_url(league)
    root_url + "leagues/#{league.to_param}?h=#{league.hmac}"
  end

  def league_path(league)
    "/leagues/#{league.to_param}?h=#{league.hmac}"
  end
end

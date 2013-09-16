module UrlHelper
  def league_url(league, params = {})
    root_url[0..-2] + league_path(league, params)
  end

  def league_path(league, params = {})
    params[:h] = league.hmac
    "/leagues/#{league.to_param}?#{params.to_param}"
  end

end

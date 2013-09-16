module UrlHelper
  def league_url(league, options = {})
    options[:controller] = 'leagues'
    options[:action] = 'show'
    options[:id] = league.id
    options[:h] = league.hmac
    options[:subdomain] = league.subdomain

    options[:only_path] ||= false

    url_for(options)
  end
  alias_method :nfl_league_url, :league_url
  alias_method :nba_league_url, :league_url


  def league_path(league, options = {})
    options[:only_path] = true
    league_url(league, options)
  end
  alias_method :nfl_league_path, :league_path
  alias_method :nba_league_path, :league_path
end

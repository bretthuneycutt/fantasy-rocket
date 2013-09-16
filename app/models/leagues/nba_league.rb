class NBALeague < League

  def subdomain
    "nba"
  end

private

  def valid_type?
    true
  end
end

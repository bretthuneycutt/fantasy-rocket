module I18nHelper
  def sport_t(string)
    t [current_sport,string].join(".")
  end
end

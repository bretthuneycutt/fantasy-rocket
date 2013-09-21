module I18nHelper
  def sport_t(string)
    t [Sport.key,string].join(".")
  end
end

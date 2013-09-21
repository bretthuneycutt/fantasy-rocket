class SplashController < ApplicationController
  def index
    if current_user && league = current_user.leagues.where(sport: Sport.key).first
      return redirect_to league
    end
  end
end

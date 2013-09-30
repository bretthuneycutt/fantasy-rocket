class SplashController < ApplicationController
  def index
    if current_user && league = current_user.leagues.where(sport: current_sport).first
      return redirect_to league
    end
  end

  def pricing
  end
end

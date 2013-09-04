class SplashController < ApplicationController
  def index
    if current_user && current_user.leagues.size > 0
      return redirect_to(current_user.leagues.first)
    end
  end
end

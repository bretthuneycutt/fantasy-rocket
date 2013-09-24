class MembershipModalDecorator < ModalDecorator
  def what_happened
    "You've joined #{model.league.name}"
  end

  def call_to_action
    "Share your league and invite more friends to play!"
  end

  def url
    league_url(model.league, host: request.host)
  end
end

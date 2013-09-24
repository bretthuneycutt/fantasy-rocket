class DraftPickModalDecorator < ModalDecorator
  def what_happened
    "You picked the #{model.team.name} #{model.as_ordinal}"
  end

  def call_to_action
    "Share your pick with friends!"
  end

  def url
    league_url(model.league, host: request.host)
  end
end

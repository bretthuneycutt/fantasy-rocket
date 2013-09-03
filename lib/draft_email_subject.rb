class DraftEmailSubject
  attr_reader :draft, :user

  def initialize(draft, user)
    @draft = draft
    @user = user
  end

  def to_s
    "FantasyRocket draft update"
  end
end

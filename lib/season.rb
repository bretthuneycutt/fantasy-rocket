class Season
  def self.started?
    # returns true if a win has been recorded
    Team.win_counts.values.any?{ |v| v > 0 }
  end
end

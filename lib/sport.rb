class Sport
  def self.key=(key)
    @key = key.andand.to_sym
  end

  def self.key
    @key || :nfl
  end
end

class ModalDecorator
  include UrlHelper
  include Rails.application.routes.url_helpers

  attr_reader :model, :request
  delegate :default_tweet, to: :model

  def initialize(model, request)
    @model = model
    @request = request
  end

  def what_happened
    raise "define in subclass"
  end

  def call_to_action
    raise "define in subclass"
  end

  def url
    raise "define in subclass"
  end
end

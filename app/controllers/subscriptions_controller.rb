class SubscriptionsController < ApplicationController
  force_ssl  unless Rails.env.development?
  before_filter :current_user!
  before_filter :redirect_subscribers, :if => Proc.new { current_user.subscriber? }

  def new
    @subscription = current_user.build_subscription
  end

  def create
    current_user.create_subscription!
    redirect_to params[:redirect_to] || root_url, notice: "Thanks! You're now subscribed."
  end

private

  def redirect_subscribers
    redirect_to params[:redirect_to] || root_url, notice: "You're already a subscriber!"
  end
end

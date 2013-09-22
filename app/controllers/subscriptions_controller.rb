class SubscriptionsController < ApplicationController
  force_ssl  unless Rails.env.development?
  before_filter :current_user!
  before_filter :redirect_subscribers, :if => Proc.new { current_user.subscriber? }

  def new
    @subscription = current_user.build_subscription
  end

  # TODO rescue errors
  # TODO consider using a service object to encapsulate logic, e.g., Customer
  def create
    customer = Stripe::Customer.create({
      :description => current_user.id,
      :email => current_user.email,
      :card => params[:stripeToken],
    })

    current_user.stripe_id = customer.id
    current_user.save!

    Stripe::Charge.create(
      :customer    => current_user.stripe_id,
      :amount      => 250,
      :description => 'Fantasy Rocket Monthly Subscription',
      :currency    => 'usd',
    )

    current_user.create_subscription!
    redirect_to params[:redirect_to] || root_url, notice: "Thanks! You're now subscribed."
  end

private

  def redirect_subscribers
    redirect_to params[:redirect_to] || root_url, notice: "You're already a subscriber!"
  end
end

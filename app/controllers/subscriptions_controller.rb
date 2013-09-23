class SubscriptionsController < ApplicationController
  force_ssl  unless Rails.env.development?
  before_filter :current_user!
  before_filter :redirect_subscribers, :if => Proc.new { current_user.subscriber? }, :only => [:new, :create]

  def new
    @subscription = current_user.build_subscription
  end

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
  rescue Stripe::CardError => e
    redirect_to new_subscriptions_path, alert: e.message
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    subscription = customer.cancel_subscription(at_period_end: true)
    current_user.subscription.cancel!(subscription.current_period_end)
    redirect_to edit_users_url, notice: "Thanks, we cancelled your subscription"
  end

private

  def redirect_subscribers
    redirect_to params[:redirect_to] || root_url, notice: "You're already a subscriber!"
  end
end

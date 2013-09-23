Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'] || "pk_test_Z6DtFKiZlVmKzDcnyV1Tds2C",
  :secret_key      => ENV['SECRET_KEY'] || "sk_test_Zt9yfN4fZCWlMyUFVtFsWcGx",
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

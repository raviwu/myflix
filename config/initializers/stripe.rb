Stripe.api_key = Rails.env.production? ?  ENV['STRIPE_LIVE_SECRET_KEY'] : 'sk_test_2gB1xh7jwrowOkemhCZrhR4N'

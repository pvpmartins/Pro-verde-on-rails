class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    # Verify the event by signature
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET'])
    rescue JSON::ParserError => e
      # Invalid payload
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return head :bad_request
    end

    case event['type']
    when 'invoice.payment_failed'
      # Handle payment failure (e.g., cancel subscription)
      handle_failed_payment(event)
    when 'invoice.payment_succeeded'
      # Handle successful payment (e.g., renew subscription)
      handle_successful_payment(event)
    end

    head :ok
  end

  private

  def handle_failed_payment(event)
    # Find the related subscription and update its status
    subscription = Subscription.find_by(stripe_subscription_id: event['data']['object']['subscription'])
    subscription.cancel_subscription if subscription
  end

  def handle_successful_payment(event)
    # Find the related subscription and renew it
    subscription = Subscription.find_by(stripe_subscription_id: event['data']['object']['subscription'])
    subscription.renew_subscription if subscription
  end
end


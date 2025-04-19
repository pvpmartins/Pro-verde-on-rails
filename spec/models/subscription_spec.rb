require 'rails_helper'

RSpec.describe "Subscriptions", type: :request do
  describe "GET /plans/success", type: :request do
    let(:user) { create(:user) }
    let(:plan) { create(:plan) }
    let(:frequency) { create(:plan_frequency, plan: plan) }

    let(:stripe_session) do
      double('Stripe::Checkout::Session', id: 'cs_test_123')
    end

    before do
      sign_in user  # assuming Devise
      allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_session)
    end

    it "creates a subscription and shows success page" do
      get success_users_plan_path(plan), params: {
        session_id: stripe_session.id,
        plan_frequency_id: frequency.id
      }

      expect(response).to be_successful
      expect(Subscription.last.status).to eq("active")
    end
  end
end

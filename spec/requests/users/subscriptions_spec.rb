require 'rails_helper'

RSpec.describe "Users::Subscriptions", type: :request do
  describe "GET /users/subscriptions", inertia: true do
    let(:user) { create(:user, password: 'password123') }
    let!(:plan) { create(:plan) }
    let!(:frequency) { create(:plan_frequency, plan: plan) }
    let!(:subscription) { create(:subscription, user: user, plan_frequency: frequency) }

    let(:stripe_session) { double('Stripe::Checkout::Session', id: 'cs_test_123') }

    before do
      # Log in the user
      post "/session", params: {
        session: {
          email_address: user.email_address,
          password: 'password123'
        }
      }
    end

    it "renders the index page with user's subscriptions and the correct plan" do
      get users_subscriptions_path
      puts inertia.props

      expect(inertia.props[:subscriptions][0][:plan][:name]).to eq 'Premium'

      expect(inertia.props[:subscriptions][0][:plan_frequency][:delivery_frequency]).to eq 'biweekly'
      expect(inertia.props[:subscriptions].all? { |s| s[:status] == 'active' }).to be true
    end

    it "check the subscription status after choosing plan" do
      allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_session)

      get success_users_plan_path(plan.id), params: {
        session_id: stripe_session.id,
        plan_frequency_id: frequency.id
      }

      expect(inertia.props[:subscription][:status]).to eq 'active'
    end
  end
end


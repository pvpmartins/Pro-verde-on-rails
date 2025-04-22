require 'rails_helper'

RSpec.describe "Admin::Subscriptions", type: :request do
  fixtures :plans, :subscriptions, :plan_frequencies, :users, :roles, :roles_users

  describe "GET /index", inertia: true do

    let!(:admin_role) { Role.create!(name: 'admin') }

    let(:admin) do
      user = create(:user)
      user.roles << admin_role
      user
    end


    let!(:users) { create_list(:user, 3) }

    before do
      # log in the user
      post "/session", params: {
        session: {
          email_address: admin.email_address,
          password: 'password123'
        }
      }
    end

    it "should load subscriptions properly" do
      post "/session", params: {
        session: {
          email_address: admin.email_address,
          password: 'password123'
        }}
      
      get admin_subscriptions_path
      
      subscriptions = inertia.props[:subscriptions]

      expect(subscriptions.all? { |s| s.start_date.nil? }).to be false
      expect(subscriptions.all? { |s| s.status.nil? }).to be false
      expect(subscriptions.all? { |s| s.id.nil? }).to be false
      expect(subscriptions.all? { |s| s.user_id.nil? }).to be false
      expect(subscriptions.all? { |s| s.plan_frequency_id.nil? }).to be false
    end

    it "should not load subscriptions properly" do
      post "/session", params: {
        session: {
          email_address: users[0].email_address,
          password: 'password123'
        }}
      
      get admin_subscriptions_path
      
      expect(response).to redirect_to '/unauthorized'
    end


    it "should a subscription through Inertia Lazy props properly" do
      subscription_id = Subscription.first.id

      post "/session", params: {
        session: {
          email_address: admin.email_address,
          password: 'password123'
        }}
      
      get admin_subscriptions_path, params: {
        subscription_id: subscription_id
      }, headers: {
        'X-Inertia' => 'true',
        'X-Inertia-Partial-Component' => 'Admin/Subscriptions/Index',
        'X-Inertia-Partial-Data' => 'subscription'
      }
      subscription = inertia.props["subscription"]

      expect(subscription["status"]).to be_present
      expect(subscription["id"]).to be_present
      expect(subscription["created_at"]).to be_present
      expect(subscription["updated_at"]).to be_present
      expect(subscription["start_date"]).to be_present
      expect(subscription["plan"]["delivery_frequency"]).to be_present 
      expect(subscription["plan"]["id"]).to be_present 
      expect(subscription["user"]["email_address"]).to be_present 
      expect(subscription["user"]["first_name"]).to be_present 
      expect(subscription["user"]["last_name"]).to be_present 
      expect(subscription["user"].has_key?("roles")).to be_present 
    end
  end
end

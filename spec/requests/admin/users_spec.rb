require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
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


  describe "GET /index", inertia: true do
    it "renders the index page successfully" do
      get admin_users_path

      puts "RESPONSE #{inertia.props}"


      users_res = inertia.props[:users]

      expect(response).to have_http_status(:ok)
      expect(users_res.all? { |s| s.id.nil? }).to be false
      expect(users_res.all? { |s| s.first_name.nil? }).to be false
      expect(users_res.all? { |s| s.last_name.nil? }).to be false
      expect(users_res.all? { |s| s.email_address.nil? }).to be false
      expect(users_res.all? { |s| s.role_id }).not_to be_nil
      expect(users_res.all? { |s| s.has_attribute?(:password_digest) }).not_to be true
    end
  end
end

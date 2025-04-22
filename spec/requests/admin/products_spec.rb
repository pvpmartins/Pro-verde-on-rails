require 'rails_helper'

RSpec.describe "Admin::Products", type: :request do
  fixtures :users, :products, :categories

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

    it "should fail at loading products" do
      post "/session", params: {
        session: {
          email_address: users[0].email_address,
          password: 'password123'
        }}
      
      get admin_products_path

      expect(response.status).to eq 302
      expect(response).to redirect_to '/unauthorized'
    end

    it "should succeed at loading products" do
      post "/session", params: {
        session: {
          email_address: admin.email_address,
          password: 'password123'
        }
      }
      get admin_products_path

      products = inertia.props[:products]

      expect(products.all? { |p| p.has_key?("description") }).to be false 
      expect(products.all? { |p| p.has_key?("category") }).to be false 
      expect(response.status).to eq 200 
      expect(inertia.component).to eq "Admin/Products/Index" 
    end

  describe "GET /show", inertia: true do

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

    it "should show a product with the category" do
      category = Category.first
      get admin_product_path(category)
      
      puts "INERTIA PROPS #{inertia.props}"
      product = inertia.props[:product]
      category = product["category"]
      category_name = category["name"]

      expect(category_name).to be_a(String)
      expect(category_name).not_to be_empty
      expect(product.has_key?("description")).to be true 
    end

  end

  describe "DELETE", inertia: true do

    let!(:admin_role) { Role.create!(name: 'admin') }

    let(:admin) do
      user = create(:user)
      user.roles << admin_role
      user
    end

    

    let!(:users) { create_list(:user, 3) }

    it "should delete a product" do
      product = Product.first

      delete admin_product_path(product.id)

      expect {
        Product.find(product.id)  # assuming this ID doesn't exist
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  end
end

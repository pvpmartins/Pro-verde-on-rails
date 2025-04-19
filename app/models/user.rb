class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :user
  has_and_belongs_to_many :roles

  def has_permission?(permission)
    roles.any? { |role| role[permission] }
  end

  enum :role, { user: 0, admin: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

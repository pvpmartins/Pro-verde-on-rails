class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_and_belongs_to_many :roles

  def has_permission?(permission)
    roles.any? { |role| role[permission] }
  end

  def only_one_admin_allowed
    return unless roles.any? { |r| r.name == 'admin' }

    existing_admin = User.joins(:roles).where(roles: { name: 'admin' }).where.not(id: id).first
    if existing_admin.present?
      errors.add(:roles, 'Admin role is already assigned to another user.')
    end
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

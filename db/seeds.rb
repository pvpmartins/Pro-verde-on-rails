# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = User.find_or_create_by!(email_address: 'admin@example.com') do |user|
  user.password = 'securepassword'
  user.email_address = 'admin@example.com'
  user.first_name = 'Admin'
end

role = Role.find_or_create_by!(name: 'admin')
admin.roles << role unless admin.roles.include?(role)

puts "Admin created!"

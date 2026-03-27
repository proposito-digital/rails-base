# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

return unless Rails.env.development?

[
  { email_address: "test@test.com", password: "test@123" },
  { email_address: "dev@dev.com", password: "test@123" }
].each do |attributes|
  User.find_or_create_by!(email_address: attributes[:email_address]) do |user|
    user.password = attributes[:password]
    user.password_confirmation = attributes[:password]
  end
end

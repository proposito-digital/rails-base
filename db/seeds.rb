return unless Rails.env.development?

[
  { email_address: "test@test.com", password: "test@123", admin: false },
  { email_address: "dev@dev.com", password: "test@123", admin: true }
].each do |attributes|
  User.find_or_create_by!(email_address: attributes[:email_address]) do |user|
    user.password = attributes[:password]
    user.password_confirmation = attributes[:password]
  end
end

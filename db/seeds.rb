# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def find_or_create(model, attributes)
  model.constantize.find_or_create_by(attributes)
end

if Rails.env.development?
  user = find_or_create("User", {email: 'admin@example.com'})
  user.update_attribute(:password, "password")
  admin = find_or_create("AdminUser", {email: 'admin@example.com'})
  admin.update_attribute(:password, "password")
elsif Rails.env.staging? or Rails.env.production?
  user = find_or_create("User", {email: 'admin@example.com'})
  user.update_attribute(:password, "password")
  admin = find_or_create("AdminUser", {email: 'admin@example.com'})
  admin.update_attribute(:password, "password")
end



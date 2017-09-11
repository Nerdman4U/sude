# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def find_or_create(model, attributes, &block)
  model.constantize.find_or_create_by(attributes, &block)
end

if Rails.env.development? or Rails.env.staging? or Rails.env.production?
  # Users  
  user = find_or_create("User", {email: 'admin@suorademokratia.net'}) { |u| u.fullname = "Admin" }
  user.update_attribute(:password, "password")
  admin = find_or_create("AdminUser", {email: 'admin@suorademokratia.net'})
  admin.update_attribute(:password, "password")
  user1 = find_or_create("User", {email: 'mikko.vapa@suorademokratia.net'}) { |u| u.fullname = "Mikko Vapa"; u.username = "mikkovapa"}
  user.update_attribute(:password, "password")
  user2 = find_or_create("User", {email: 'marko.vapa@suorademokratia.net'}) { |u| u.fullname = "Marko Vapa"; u.username = "markovapa"}
  user.update_attribute(:password, "password")
  user3 = find_or_create("User", {email: 'niko.kauko@suorademokratia.net'}) { |u| u.fullname = "Niko Kauko"; u.username = "nikokauko"}
  user.update_attribute(:password, "password")
  user4 = find_or_create("User", {email: 'joni.toyryla@suorademokratia.net'}) { |u| u.fullname = "Joni Töyrylä"; u.username = "jonitoyryla"}
  user.update_attribute(:password, "password")

  # Options
  yes = find_or_create("VoteProposalOption", {name: "Yes"})
  no = find_or_create("VoteProposalOption", {name: "No"})

  # Cirles
  circle1 = find_or_create("Circle", {name: "Turvallisuus"})
  circle2 = find_or_create("Circle", {name: "Luonto"})
  circle3 = find_or_create("Circle", {name: "Teknologia"})

  # Groups
  group1 = find_or_create("Group", {name: "Suomen Demokratia ry."}) { |g|
    g.users << user1 unless g.users.include(user1)
    g.users << user2 unless g.users.include(user2)
    g.users << user3 unless g.users.include(user3)
    g.users << user4 unless g.users.include(user4)
  }
  
  # Proposals
  proposal1 = find_or_create("VoteProposal", {topic: "Pitäisikö Suomen liittyä Natoon?"}) { |p| p.circle = circle1; p.vote_proposal_options << [yes, no] }
  proposal1 = find_or_create("VoteProposal", {topic: "Julkaistaanko suorademokratia.net tämän vuoden puolella?"}) { |p|
    p.circle = circle3;    
    p.vote_proposal_options << yes unless p.vote_proposal_options.include?(yes)
    p.vote_proposal_options << no unless p.vote_proposal_options.include?(no)
    p.groups << group1 unless p.groups.include(gruop1)
  }
  
end



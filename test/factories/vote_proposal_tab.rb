FactoryGirl.define do
  factory :vote_proposal_tag do
    name { Faker::Color.color_name }
  end
end


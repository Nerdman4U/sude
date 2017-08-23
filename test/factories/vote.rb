FactoryGirl.define do
  factory :vote do
    user
    association :vote_proposal, :with_options
  end
end

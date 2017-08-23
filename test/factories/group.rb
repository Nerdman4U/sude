FactoryGirl.define do
  factory :group do
    name { Faker::Company.name }

    trait :with_proposals do
      transient do
        proposal_count 3
      end
      after(:create) do |group, evaluator|
        create_list(:vote_proposal, evaluator.proposal_count, groups: [group])
      end
    end

    factory :group_with_proposals, traits: [:with_proposals]
  end
end

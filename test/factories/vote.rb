FactoryGirl.define do
  factory :vote do
    user
    association :vote_proposal, :with_options, max_options: 3

    trait :with_options do
      transient do
        options_count 3
      end
      after(:create) do |vote, evaluator|
        create_list(:vote_proposal_option, evaluator.options_count, votes: [vote])
      end
    end
    
  end
end

FactoryGirl.define do
  factory :vote_proposal do
    trait :two_options do
      transient do
        vote_proposal_options_count 2
      end
      after(:create) do |vote_proposal, evaluator|
        create_list(:vote_proposal_option, evaluator.vote_proposal_options_count, vote_proposals: [vote_proposal])
      end
    end
    factory :vote_proposal_with_2_options, traits: [:two_options]
  end
end



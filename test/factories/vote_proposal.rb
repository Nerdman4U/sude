FactoryGirl.define do
  factory :vote_proposal do
    topic "Ehdotus 1"
    max_options 1
    min_options 1
    
    trait :with_options do
      transient do
        options_count 2
      end
      after(:create) do |vote_proposal, evaluator|
        create_list(:vote_proposal_option, evaluator.options_count, vote_proposals: [vote_proposal])
      end
    end

    trait :with_tags do
      transient do
        tags_count 3
      end
      after(:create) do |vote_proposal, evaluator|
        create_list(:vote_proposal_tag, evaluator.tags_count, vote_proposals: [vote_proposal])
      end
    end

    trait :with_groups do
      transient do
        groups_count 3
      end
      after(:create) do |vote_proposal, evaluator|
        create_list(:group, evaluator.groups_count, vote_proposals: [vote_proposal])
      end
    end
    
    trait :with_votes do
      transient do
        votes_count 3
      end
      after(:create) do |vote_proposal, evaluator|
        create_list(:vote, evaluator.votes_count, vote_proposal: vote_proposal)
      end
    end
    
    trait :with_users do
      transient do
        users_count 3
      end
      after(:create) do |vote_proposal, evaluator|
        create_list(:user, evaluator.users_count, vote_proposals: [vote_proposal])
      end
    end
    
    factory :vote_proposal_with_options, traits: [:with_options]
    factory :vote_proposal_with_tags, traits: [:with_tags]
    factory :vote_proposal_with_groups, traits: [:with_groups]
    factory :vote_proposal_with_votes, traits: [:with_votes]
  end
end



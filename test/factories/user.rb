FactoryGirl.define do
  factory :user do
    fullname { [Faker::Name.first_name, Faker::Name.last_name].join(" ") }
    email { Faker::Internet.safe_email(fullname) }
    username { Faker::Internet.user_name(fullname) }
    password { "password" }

    trait :with_group do
      transient do
        groups_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:group, evaluator.groups_count, users: [user])
      end
    end

    trait :with_group_with_proposals do
      transient do
        groups_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:group_with_proposals, evaluator.groups_count, users: [user])
      end
    end
    
    
    trait :with_votes do
      transient do
        votes_count 3
      end
      after(:create) do |user, evaluator|
        create_list(:vote, evaluator.votes_count, user: user)
      end
    end

    factory :user_with_group, traits: [:with_group]
    factory :user_with_votes, traits: [:with_votes]
    factory :user_with_group_and_votes, traits: [:with_group, :with_votes]
    factory :user_with_group_with_proposals, traits: [:with_group_with_proposals]
  end  
end

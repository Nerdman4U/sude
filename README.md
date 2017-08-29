# Direct Democracy

This is simple Direct Democracy software.

## Getting Started

1) Get the code
2) Verify you have installed all prerequisite software
3) Bundle install
4) Rake test
5) Rails server

## Models

### Users
User can be anonymous, signed up but unverified or
verified. Verification is done with checkout.fi API. Verified user must
succesfully use web bank mmoney transfer.

### VoteProposal
A record that can be voted.

### Vote
A vote for one proposal.

### Group
Vote proposal can be generic or it can have a group. Vote proposals in
groups are accessible only users who are members of the groups.  

### Circles
Vote proposals are added to the system through group of people, "talking
circle". This means that multiple people will be involved to create
content and multiple people must accept the final proposal to make it
votable. 

### Prerequisites

Ruby 2.3.1

## Running the tests

$ rake test

With "single_test" gem spesific tests can be ran easily

$ rake test:user                 (model)
$ rake test:user:should          (model test with regexp)
$ rake test:vote:proposals       (functional)

## Contributing

I will write here stuff i know needs to be written better.

1) FactoryGirl
   How to add factory to create assosiated record from another
   associated record previously created?

   Can i do something like:
   vote = create(:vote_with_proposal, user: user)
   see vote.rb

2) VoteProposalsController#index
   Too many queries. Should have SQL query to include all related data
   in one query.

3) Vote.rb
   Validation of the vote count is too heavy
   (user_can_have_only_one_vote_per_proposal)

4) Acceptance tests (Capybara/Selenium)
   Only few tests written.. should have more


## Versioning

https://github.com/nerdman/direct_democracy

## Authors

* **Joni Töyrylä** - *Initial work, version 1.0* - [Nerdman](https://github.com/nerdman)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc

# ============================== CLIP

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

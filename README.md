# Direct Democracy

This is simple Direct Democracy software.

## Getting Started

1) Get the code
2) Verify you have installed all prerequisite software
3) Bundle install
4) Rake test
5) Rails server

## See the demo
http://suorademokratia.net

## Contribute!

We need your help. Please, see the list below and feel free to get excited

I will write here stuff i know needs to be written better.

### Requests

    Index and Show post/put requests are full requests. Should be ajax
    and json. Needs some frontend library plans perhaps.

### Permissions

    Most permission checks are missing.

    For example at:
    User#vote

### Search queries

    Should install search engine for efficient searches, for example solr
    https://github.com/sunspot/sunspot               

### FactoryGirl

    Some factories could be more complex.

    see: factories/vote.rb

### VoteProposalsController#index

   Too many queries. Should have SQL query to include all related data
   in one query.

### Vote.rb

   Validation of the vote count is too heavy
   (user_can_have_only_one_vote_per_proposal)

### Acceptance tests (Capybara/Selenium)

   Only few tests written.. should have more



## Technical

### Models

#### Users
User can be anonymous, signed up but unverified or
verified. Verification is done with checkout.fi API. Verified user must
succesfully use web bank mmoney transfer.

#### VoteProposal
A record that can be voted.

#### Vote
A vote for one proposal.

#### Group
Vote proposal can be generic or it can have a group. Vote proposals in
groups are accessible only users who are members of the groups.  

#### Circles
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

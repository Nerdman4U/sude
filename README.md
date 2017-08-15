# Direct Democracy

This is simple Direct Democracy software.

## Getting Started

### Users
User can be anonymous, signed up but unverified or verified. Verification is done with checkout.fi API. Verified user must succesfully use web bank mmoney transfer.

### Groups
Any vote proposal can be global, i.e. without a group or it can have a group. Vote proposals in groups are accessible only users who are members of the groups. 

### Circles
Vote proposals are added to the system through "talking circle". This means that multiple people will be involved to create content and multiple people must accept the final proposal to make it votable.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Ruby 2.3.1

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

$ rake test

Or run spesific file and/or test case 
$ rake test:vote:proposal

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

There is a lot to be done. Feel free to help!

### VoteProposal.rb

* SQL queries could be made more compact

### Vote.rb

* Validation of the vote count is too heavy (user_can_have_only_one_vote_per_proposal)


Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use Github for versioning.


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

# README

You can use this app to find followers of a given user.

##### If the user has not already been searched for:

1) You can submit a form to query the Twitter API for their followers

2) Followers will then be returned to you from the Twitter API immediately

##### If the user has already been searched for:

1) You can click on their username to view their followers stored in the database

2) You'll be redirected to the appropriate user page and all the stored followers will be returned to you.

##### Bonus

After users and followers have been stored in the database, these followers are updated periodically every 12 hours using a batch worker.

### About the app

This app uses the `twitter` gem to query the Twitter API.

It uses VCR to mock the API calls.

It also uses Sidekiq and Redis to queue workers so that the user doesn't have to wait around for the followers to be stored in the database.

It is deployed on Heroku via: https://find-followers.herokuapp.com/

IMPORTANT: Occassionally you may not be able to search for users due to the following error:

`Twitter::Error::TooManyRequests - Rate limit exceeded`

For more information see here:
https://blog.twitter.com/en_us/a/2008/what-does-rate-limit-exceeded-mean-updated.html

If this happens, you may have to wait up to an hour for it to work again.

### Setup

Note - You will need to have redis installed:
```
gem install redis
```

To run the app, do the following:

```
git clone git@github.com:rubyandcoffee/find_followers.git
cd find_followers
```
Now you'll need to set your environment keys in a `.env` file at the root of the project:
```
TWITTER_CONSUMER_KEY=yourtwitterconsumerkey
TWITTER_CONSUMER_SECRET=yourtwitterconsumersecret
TWITTER_ACCESS_TOKEN=yourtwitteraccesstoken
TWITTER_ACCESS_TOKEN_SECRET=yourtwittertokensecret
SIDEKIQ_AUTH_USERNAME=yoursidekiqauthusername
SIDEKIQ_AUTH_PASSWORD=yoursidekiqauthpassword
```
Note: You only need to set `SIDEKIQ_AUTH_USERNAME` and `SIDEKIQ_AUTH_PASSWORD` if you change the sidekiq monitoring (in the routes file) to include development environment.

You can now run the app:
```
bundle exec rails server
```

Then, in another tab:
```
bundle exec sidekiq
```

And in another tab:
```
redis-server
```

You can then view the app on:
```
localhost:3000
```

# CodePath iOS Week 3: Twitter Lite

Time spent: 20 hours spent in total

Completed user stories:

* [x] Required: User can sign in using OAuth login flow
* [x] Required: User can view last 20 tweets from their home timeline
* [x] Required: The current signed in user will be persisted across restarts
* [x] Required: In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
* [x] Required: User can pull to refresh
* [x] Required: User can compose a new tweet by tapping on a compose button.
* [x] Required: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
* [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
* [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
* [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
* [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
* [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
* [x] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client

Additonal things I tried to experiment with:
* Links within the tweets (only added to the main view)
* Image within the tweets (only added to the main view)

Questions and Known Issues:
* Un-retweet only works when I retweet within the same session. I need to do some more digging to figure out how to get the retweet ID if I've retweeted it in a past session.

Video Walkthroughs:

![Core experience](Screenshots/twitter.gif)
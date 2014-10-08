# CodePath iOS Week 4: Twitter Lite Redux

Time spent: 15 hours spent in total

Completed user stories:

Hamburger menu
* [x] Dragging anywhere in the view should reveal the menu.
* [x] The menu should include links to your profile, the home timeline, and the mentions view.
* [x] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.

Profile page
* [x] Contains the user header view
* [x] Contains a section with the users basic stats: # tweets, # following, # followers
* [ ] Optional: Implement the paging view for the user description.
* [ ] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
* [x] Optional: Pulling down the profile page should blur and resize the header image.

Home Timeline
* [x] Tapping on a user image should bring up that user's profile page

Questions and Known Issues:
* I had a lot of trouble setting the height of the table header on the profile page. That area seems super buggy. For instance, the height calculation breaks when I rotate the device. What's the best way to set the height?

Video Walkthroughs:

![Core experience](Screenshots/twitter2.gif)

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
#!/usr/bin/env python
# encoding: utf-8

import tweepy #https://github.com/tweepy/tweepy
import csv
import config
import jsonpickle
from datetime import datetime as dt
timestamp = dt.now().strftime("%Y%m%d_%H-%M-%S")

#Twitter API credentials
consumer_key = config.CONSUMER_KEY
consumer_secret = config.CONSUMER_SECRET
access_key = config.ACCESS_KEY
access_secret = config.ACCESS_SECRET


def get_all_tweets(screen_name):
	#Twitter only allows access to a users most recent 3240 tweets with this method
	
	#authorize twitter, initialize tweepy
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_key, access_secret)
	api = tweepy.API(auth)
	
	#initialize a list to hold all the tweepy Tweets
	tweets_list = []
	
	#make initial request for most recent tweets (200 is the maximum allowed count)
	recent_tweets = api.user_timeline(screen_name = screen_name,count=200, tweet_mode='extended')
	
	#save most recent tweets
	tweets_list.extend(recent_tweets)
	
	#save the id of the oldest tweet less one
	oldest = tweets_list[-1].id - 1
	
	#keep grabbing tweets until there are no tweets left to grab
	while len(recent_tweets) > 0: # change back to 0
		print("getting tweets before %s" % (oldest))
		
		#all subsequent requests use the max_id param to prevent duplicates
		recent_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest)
		
		#save most recent tweets
		tweets_list.extend(recent_tweets)
		
		#update the id of the oldest tweet less one
		oldest = tweets_list[-1].id - 1
		
		print("...%s tweets downloaded so far" % (len(tweets_list)))

	print(tweets_list[0])
	#transform the tweepy tweets into a 2D array that will populate the csv	
	#tweets_array = [[tweet.id_str, tweet.created_at, tweet.full_text.encode("utf-8")] for tweet in tweets_list]

	with open('%s_tweets.txt' % screen_name, 'w') as f:
		for tweet in tweets_list:
			f.write(jsonpickle.encode(tweet._json, unpicklable=False) + '\n')

	#write the csv	
	#with open('%s_tweets.csv' % screen_name, 'w') as f:
	#	writer = csv.writer(f)
	#	writer.writerow(["id","created_at","full_text"])
	#	writer.writerows(tweets_array)
	
	pass


if __name__ == '__main__':
	#pass in the username of the account you want to download
	get_all_tweets("JonathanWNV")

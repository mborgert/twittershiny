api_key <- "jIBvAcgaTxdz6rXRhYCDLfjLJ"
api_secret <- "HL1Gt5Bd0o1vdrfeY5ZLHUnqKrUiPFbk3rfB8pkbMW3S8kH6Qy"
access_token <- "932364140198236160-FB48mRRqMtLm7tweh9Qm12rzT75x4Vi"
access_token_secret <- "HFnmCJfOnizAgT0vDPunH5u8Bk0WHc4DPsGHk7mIIUM9T"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

pkgs <-c('twitteR','ROAuth','httr','plyr','stringr','ggplot2','plotly')
for(p in pkgs) if(p %in% rownames(installed.packages()) == FALSE) {install.packages(p)}
for(p in pkgs) suppressPackageStartupMessages(library(p, quietly=TRUE, character.only=TRUE))

tweets_trump <- searchTwitter('@realDonaldTrump', n=30)
tweets_sanders <- searchTwitter('@BernieSanders', n=30)
tweets_clinton <- searchTwitter('@HillaryClinton', n=30)
tweets_cruz <- searchTwitter('@tedcruz', n=30)

feed_trump <- laply(tweets_trump, function(t) t$getText())
feed_sanders <- laply(tweets_sanders, function(t) t$getText())
feed_clinton <- laply(tweets_clinton, function(t) t$getText())
feed_cruz <- laply(tweets_cruz, function(t) t$getText())

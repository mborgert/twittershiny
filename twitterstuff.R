
pkgs <-c('twitteR','ROAuth','httr','plyr','stringr','ggplot2','plotly')
for(p in pkgs) suppressPackageStartupMessages(library(p, quietly=TRUE, character.only=TRUE))

api_key <- "jIBvAcgaTxdz6rXRhYCDLfjLJ"
api_secret <- "HL1Gt5Bd0o1vdrfeY5ZLHUnqKrUiPFbk3rfB8pkbMW3S8kH6Qy"
access_token <- "932364140198236160-FB48mRRqMtLm7tweh9Qm12rzT75x4Vi"
access_token_secret <- "HFnmCJfOnizAgT0vDPunH5u8Bk0WHc4DPsGHk7mIIUM9T"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

good_text <- scan("poswords.txt", what='character', comment.char=';')
bad_text <- scan("negwords.txt", what='character', comment.char=';')

score.sentiment <- function(sentences, good_text, bad_text, .progress='none')
{
  require(plyr)
  require(stringr)
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array of scores back, so we use
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, good_text, bad_text)   {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    #to remove emojis
    sentence <- iconv(sentence, 'UTF-8', 'ASCII')
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, good_text)
    neg.matches = match(words, bad_text)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, good_text, bad_text, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

gettweets = function(name,num){
  tweets = userTimeline("@realDonaldTrump",n=100,includeRts=TRUE)
  feed = laply(tweets, function(t) t$getText())
  plotdat = score.sentiment(feed,good_text,bad_text,.progress='text')
  plotdat <- plotdat[!plotdat$score == 0, ]
  plotdat$score = as.factor(plotdat$score)
  ggplot(plotdat, aes(x=score)) + geom_bar() + ggtitle(name)
}








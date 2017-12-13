good_text <- scan("poswords.txt", what='character', comment.char=';')
bad_text <- scan("negwords.txt", what='character', comment.char=';')

score.sentiment <- function(sentences, good_text, bad_text, .progress='none')
{
  require(plyr)
  require(stringr)
    
  scores = laply(sentences, function(sentence, good_text, bad_text)   {
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    sentence <- iconv(sentence, 'UTF-8', 'ASCII')
    sentence = tolower(sentence)
    word.list = str_split(sentence, '\\s+')
    words = unlist(word.list)
    pos.matches = match(words, good_text)
    neg.matches = match(words, bad_text)
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    score = sum(pos.matches) - sum(neg.matches)
    return(score)
  }, good_text, bad_text, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

gettweets = function(name,num){
  tweets = userTimeline(name,n=num,includeRts=TRUE)
  feed = laply(tweets, function(t) t$getText())
  plotdat = score.sentiment(feed,good_text,bad_text,.progress='text')
  plotdat <- plotdat[!plotdat$score == 0, ]
  plotdat$score = as.factor(plotdat$score)
  ggplot(plotdat, aes(x=score)) + geom_bar() + ggtitle(name)
}







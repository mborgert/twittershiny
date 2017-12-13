source("helpers.R")

library(twitteR)
library(ROAuth)
library(httr)
library(plyr)
library(stringr)
library(ggplot2)
library(plotly)
library(shiny)
library(shinythemes)

#setwd("C:/Users/mitch/Documents/School/399/twittershiny")


setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

ui <- fluidPage(theme = shinytheme("paper"),
  titlePanel("Sentiment Analysis on Twitter Data"),
  tabsetPanel(type = "pills",
              tabPanel("APP",
  sidebarLayout(
    sidebarPanel(
      helpText(h2("Input")),
      
      textInput("text", h3("Twitter User"), 
                value = "@"),
      
      numericInput("num", 
                 h3("Number of Tweets"), 
                 value = 20)),
    
    
    mainPanel(
      plotOutput("tweets")
      )
    )),tabPanel("TUTORIAL",
    
      p(h4("This shiny app takes an input of a twitter user and n number of tweets. It then scores them by comparing the words in the tweets to 
          a list of negative and positive words. For every negative word, a tweet gets -1 and for every positive word it gets +1. For example, a tweet with a score of 3 would probably be positive.
           The majority of tweets get 0 as a score so those are omitted. I'm going to walk through how this app was created."), h3("Step 1: Getting access to tweets:"), 
        h4("Make a twitter account and go to https://apps.twitter.com/. Then create a new app and go to keys and access tokens of the app.
           You will want to save the api key, ap secret, access token, and access token secret. It looks like this:")), 
          img(src = "tokens.JPG", height = 400, width = 600), h3("Step 2: The sentiment analysis function: "), h4("This function will take the tweets and compare each word to two lists of words, one 'good' and one 'bad'.
           For every good word the tweet will get +1 and -1 for every bad word."), img(src = "sentfun.JPG",height = 400, width = 600),
           h3("Step 3: A function to get the tweets and plot the sentiment scores:"), h4("We need to make a function to get the tweets, run them 
          through the sentiment function, and plot them. Mine looked like this: "), img(src = "tweetplot.JPG", height = 200, width = 600), 
          h4("Once you have both of these functions, put them in a R script and save it as 'helpers.R'."), h3("Step 4: We are ready to create the shiny app, first start a new R script and save it as app.R: "), 
          h4("First, You will need the packages twitteR, ROAuth, httr, plyr, stringr, ggplot2, plotly, shiny, and shinythemes. After you have loaded those, you need to 
           connect to twitter. Make variables of the keys and access tokens you saved earlier. Then use this code to connect to twitter: 'setup_twitter_oauth(api_key, api_secret, access_token, 
             access_token_secret)'. This is from the ROAuth package. You will also want to do 'source(helpers.R)' to be able to use the functions in your app."), h4("Lets make the apps ui. All you really need to mess with is the sidbarLayout() 
          function. Inside it you put the functions that take text and numeric input into sidbarPanel(). Then in mainPanel() we put our sentiment plot.
        The code looks like this, (you can ignore anything in p() in mainPanel())."), img(src = "ui.JPG",height = 500, width = 400),
         h4("And now lets create the server. The server is where you want to take the input and use it to create and output. In this case we are taking
            text and numeric data and using our gettweets function to create a graph. Here's my code:"),img(src = "server.JPG",height = 300, width = 400),
         h3("Step 5: Running the app"), h4("At the bottom of your app.R file you will want to add 'shinyApp(ui,server)' to tell R to make a shiny app.
          After that, click run and your app should look somewhat like the top of this one. "), h3("Problems I encounted along the way:"),
        h4("1: When you load the packages, simply do it 'library(package)', if you don't, the package will not be loaded into the shiny server."),
        h4("2: Always use relative paths, not direct paths."), h4("3: When loading in the list of positive and negative words, do it in the helpers.R file, not the app file.")
        
    
    )
  )
)

server <- function(input, output) {
  output$tweets <- renderPlot({
  name = input$text
  n = input$num
  gettweets(name,n)
  })
}

shinyApp(ui, server)






source("helpers.R")

pkgs <-c('twitteR','ROAuth','httr','plyr','stringr','ggplot2','plotly','shiny')
for(p in pkgs) suppressPackageStartupMessages(library(p, quietly=TRUE, character.only=TRUE))

api_key <- "jIBvAcgaTxdz6rXRhYCDLfjLJ"
api_secret <- "HL1Gt5Bd0o1vdrfeY5ZLHUnqKrUiPFbk3rfB8pkbMW3S8kH6Qy"
access_token <- "932364140198236160-FB48mRRqMtLm7tweh9Qm12rzT75x4Vi"
access_token_secret <- "HFnmCJfOnizAgT0vDPunH5u8Bk0WHc4DPsGHk7mIIUM9T"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

good_text <- scan("C:/Users/mitch/Documents/School/399/twittershiny/poswords.txt", what='character', comment.char=';')
bad_text <- scan("C:/Users/mitch/Documents/School/399/twittershiny/negwords.txt", what='character', comment.char=';')

ui <- fluidPage(
  titlePanel("ciaData"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("CIA Data"),
      
      textInput("text", h3("Text input"), 
                value = "Enter text...")),
      
      numericInput("num", 
                 h3("Numeric input"), 
                 value = 1)
    ),
    
    mainPanel(
      plotOutput("tweets")
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
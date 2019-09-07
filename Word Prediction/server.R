#reticulate::use_condaenv('myhybrid', required = TRUE)
#reticulate::use_virtualenv('capstone_env', required = TRUE)
#library(reticulate)
library(shiny)
#library(NLP)
#library(tm)
#library(RWeka)
#library(reticulate)
#use_condaenv()
source("1_predictWord.R")


shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$Tcir})
    output$prediction <- renderPrint({getWords(input$Tcir)[1]})
    output$possibleWords <- renderPrint({getWords(input$Tcir)[2:5]})
    
    
  }
)
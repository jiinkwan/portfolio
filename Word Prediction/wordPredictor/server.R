
library(shiny)
library(NLP)
library(tm)
library(RWeka)
source("1_predictWord.R")


shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$Tcir})
    output$prediction <- renderPrint({getWords(input$Tcir)})
    
    
    
  }
)
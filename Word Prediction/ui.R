
library(shiny)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Predict word "),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Text for providing a caption ----
      # Note: Changes made to the caption in the textInput control
      # are updated in the output area immediately as you type
      textInput("Tcir",
                label = "Type your sentence here:")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      h4('string you entered : '),
      verbatimTextOutput("inputValue"),
      h4('next word :'),
      verbatimTextOutput("prediction"),
      h4('other possible words :'),
      verbatimTextOutput("possibleWords")
      
      
    )
  )
)

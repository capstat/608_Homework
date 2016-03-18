suppressPackageStartupMessages(library(googleVis))
library(shiny)

# Define UI for application to create 50 state table
shinyUI(pageWithSidebar(
  headerPanel("Morality Rates by State"),
  
  #on the side
  sidebarPanel(
    
    #drop down box for cause of death with all added to the list
    uiOutput("list_cod"),
    
    #choose none, one, or multiple states
    selectInput(inputId="state_choice", label="Filter by State",
                choices=state.name, multiple=TRUE),

    #number of entries to show on a page
    numericInput(inputId="pagesize", label="States per page", 30)
  ),
  
  #main section will display the table
  mainPanel(
     htmlOutput("gvis")
  )
))
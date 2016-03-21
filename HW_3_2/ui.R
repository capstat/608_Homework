library(googleVis)
library(shiny)

#created a csv to quickly load the unique cods
getdata = read.csv("cod.csv", stringsAsFactors=FALSE)

# Define UI for application to create 50 state table
shinyUI(pageWithSidebar(
  headerPanel("Morality Rates by State"),
  
  #on the side
  sidebarPanel(
    
    selectInput(inputId="cod", label="Cause of Death",
                choices=getdata$cod),
    
    #choose none, one, or multiple states
    selectInput(inputId="state_choice", label="Filter by State",
                choices=state.name, selected="New York")
    
  ),
  
  #main section will display the table
  mainPanel(
    htmlOutput("gvis")
  )
))
suppressPackageStartupMessages(library(googleVis))
suppressPackageStartupMessages(library(dplyr))
library(shiny)

#get the csv file from github
state_df = read.csv("https://raw.githubusercontent.com/jlaurito/CUNY_IS608/master/lecture3/data/cleaned-cdc-mortality-1999-2010.csv",
                    stringsAsFactors=FALSE)
#keep only 2010 data
state_df = state_df[state_df$Year == 2010,]
#keep only columns were interested in
state_df = state_df[,c(3,5,7,9,10,11)]
colnames(state_df) = c("Cause", "State", "Year", 
                       "Deaths", "Population", "Crude Rate")
#keep only complete cases (all rows were good)
state_df = state_df[complete.cases(state_df),]
#list of cods
cod = unique(state_df$Cause)

# Define server logic required to create 50 state table
shinyServer(function(input, output) {
  
  #create a list of cods
  output$list_cod = renderUI({
    selectInput(inputId="cod", label="Cause of Death",
                choices=c("All", cod), selected="All")
  })
  
  #will display a gVisTable
  output$gvis = renderGvis({
    #if no state is chose, display all
    if(length(input$state_choice) != 0){ 
      state_df = state_df[state_df$State %in% input$state_choice,] 
    }
    #if all is chosen, do not filter by cause
    if(input$cod != "All"){
      state_df = state_df %>% filter(Cause == input$cod)
    }
    #sort the results by the crude result
    state_df = arrange(state_df, desc(`Crude Rate`))
    #display the table with paging
    gvisTable(state_df, 
              options=list(page='enable', pageSize=input$pagesize, width=800))
  })
  
})
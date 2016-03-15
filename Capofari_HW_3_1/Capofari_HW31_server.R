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
  
# Define server logic required to create 50 state table
shinyServer(function(input, output) {
  
  #will display a gVisTable
  output$gvis = renderGvis({
    #keep only complete cases (all rows were good)
    state_df = state_df[complete.cases(state_df),]
    #if no state is chose, display all
    if(length(input$state_choice) != 0){ 
      state_df = state_df[state_df$State %in% input$state_choice,] }
    #if all is chosen, do not filter by cause
    if(input$cod != "All"){ 
      state_df = state_df %>% filter(Cause == input$cod) }
    #sort the results by the crude result
    state_df = arrange(state_df, desc(`Crude Rate`))
    #display the table with paging
    gvisTable(state_df, 
              options=list(page='enable', pageSize=input$pagesize, width=800))
  })
  
})
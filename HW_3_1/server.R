library(googleVis)
library(dplyr)
library(shiny)

#get the csv file from github
state_df = read.csv("cleaned-cdc-mortality-1999-2010.csv",
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
#save cod list as a .csv 
write.csv(data.frame(cod), "cod.csv")

# Define server logic required to create 50 state table
shinyServer(function(input, output) {
  
  #will display a gVisTable
  output$gvis = renderGvis({
    #sort the results by the crude result
    state_df = arrange(state_df, desc(`Crude Rate`))
    #check if there are any choices
    if(!(is.null(input$state_choice))){
      #if there are, all dont filter, otherwise filter
      if("All" %in% input$state_choice){
        state_df = state_df
      } else{
        state_df = state_df[state_df$State %in% input$state_choice,] 
      }
    } 
    #check if there are any choices 
    if(!(is.null(input$cod))){
      #if there are, all dont filter, otherwise filter
      if("All" %in% input$cod){
        state_df = state_df
      } else{
        state_df = state_df[state_df$Cause %in% input$cod,] 
      }
    } 
    #display the table with paging
    gvisTable(state_df, 
              options=list(page='enable', 
                           pageSize=input$pagesize, 
                           width=600))
  })
  
})
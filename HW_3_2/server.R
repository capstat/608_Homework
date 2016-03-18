library(googleVis)
library(dplyr)
library(shiny)

#get the csv file from github
state_df = read.csv("cleaned-cdc-mortality-1999-2010.csv",
                    stringsAsFactors=FALSE)

#keep only columns were interested in
state_df = state_df[,c(3,5,7,9,10,11)]
colnames(state_df) = c("Cause", "State", "Year", 
                       "Deaths", "Population", "Crude Rate")
cods = unique(state_df$Cause)

#national average for each disease by year
nat_avg_yearly = state_df %>%
  group_by(Cause, Year) %>%
  summarise(Deaths=sum(Deaths), 
            Population=sum(Population)) %>%
  mutate(`Crude Rate`=round(100000*(Deaths/Population),2),
         State="National Average")
  
# Define server logic required to create 50 state table
shinyServer(function(input, output) {
  
  #create a list of cods
  output$list_cod = renderUI({
    selectInput(inputId="cod", label="Cause of Death",
                choices=cods)
  })
  
  output$text = renderText({ input$state_choice })
  
  data = reactive({ 
    temp_state = state_df %>% filter(State==input$state_choice, Cause==input$cod) %>% 
      arrange(Year)
    temp_nat_avg = nat_avg_yearly %>% filter(Cause==input$cod) %>% 
      arrange(Year)
    df = data.frame(Year = temp_state$Year,
                    US = temp_nat_avg$`Crude Rate`,
                    State = temp_state$`Crude Rate`)
    return(df)
  })
  
  #will display a gVisLineChart
  output$gvis = renderGvis({
    my_data = data()
    gvisLineChart(my_data, xvar="Year", yvar=c("State", "US"),
                  options=list(legend="top", 
                               pointSize=4,
                               vAxes="[{title:'Crude Death Rate'}]",
                               hAxes="[{title:'Year', format:'####'}]",
                               width="700",
                               series = "[{labelInLegend: ''},
                               {labelInLegend: 'National Average'}]"
                               ))
  })
  
})

library(RCurl)
library(dplyr)
library(ggplot2)
library(scales)

setwd("~/Documents/CUNY_SPS/CUNY_SPS_IS_608/608_Homework")

#retrieve data from github
dataURL <- getURL("https://raw.githubusercontent.com/jlaurito/CUNY_IS608/master/lecture1/data/inc5000_data.csv")
top5000 <- read.csv(text = dataURL, header = TRUE, stringsAsFactors = FALSE)

###################
###             ###
### QUESTION #1 ###
###             ###
###################

#create a graph distribution by state
by_state <- top5000 %>% group_by(State) %>% count(State)

p <- ggplot(data=by_state, aes(reorder(State, n), n, fill=State))
p <- p + geom_bar(stat="identity")
p <- p + theme(plot.title = element_text(size=24), 
               legend.position="none")
p <- p + ggtitle("Distribution of the 5,000\nFastest Growing Companies by State")
p <- p + geom_text(data=by_state, aes(label=n), 
                   vjust=0.2, hjust=-.3, color="black", 
                   position=position_stack(), size=2.5)
p <- p + labs(x="State", y="Number of Companies") + coord_flip()
p <- p + geom_hline(aes(yintercept=median(by_state$n)), 
                    colour="grey", linetype="longdash")
p <- p + geom_text(aes(10,median(by_state$n+10), angle=-90,
                       label="MEDIAN"), colour="grey")
p <- p + scale_y_continuous(limits=c(0, 725), 
                            expand=c(0,0))

###################
###             ###
### QUESTION #2 ###
###             ###
###################

#focus in on state with 3rd most companies
third <- tail(head(arrange(by_state, desc(n)), 3), 1)
ny <- filter(top5000, State == third$State)
by_industry <- ny %>% group_by(Industry) %>% summarize(avg.emp=mean(Employees),
                                                       med.emp=median(Employees),
                                                       range=max(Employees)-min(Employees),
                                                       sd=sd(Employees),
                                                       mad=mad(Employees))
ny <- ny %>% merge(by_industry, by="Industry") %>% 
  mutate(outlier=(Employees-med.emp)/mad)

q <- ggplot(data=filter(ny, outlier < 3, outlier > -3), 
            aes(Industry, Employees, fill=Industry))
q <- q + geom_boxplot(outlier.shape = NA)
q <- q + theme(plot.title = element_text(size=24), 
               legend.position="none")
q <- q + labs(x=" ")
q <- q + ggtitle("New York Employees by Industry")
q <- q + scale_y_continuous(limits=c(0, 350), 
                            expand=c(0,0)) + coord_flip()

###################
###             ###
### QUESTION #3 ###
###             ###
###################

#Which industries generate the most revenue per employee
emp_rev <- top5000 %>% group_by(Industry) %>% 
  summarize(emp=sum(Employees, na.rm=TRUE),
            ratio=(sum(Revenue, na.rm=TRUE)/sum(Employees, na.rm=TRUE)))

r <- ggplot(data=emp_rev, aes(reorder(Industry, ratio), ratio))
r <- r + geom_point(color="firebrick", aes(size=emp)) 
r <- r + scale_size_area(name="Total # of\nEmployees")
r <- r + ggtitle("Revenue per Employee")
r <- r + labs(x=" ", 
              y="Revenue per Employee ($)")
r <- r + theme(plot.title = element_text(size=24),
               legend.title = element_text(color="firebrick"))
r <- r + scale_y_continuous(labels=dollar) + coord_flip()

#already saved file to my computer and uploaded to BB
saved = TRUE
if(!saved){
  ggsave("Capofari_HW_1.1.jpg", plot=p, scale=1, 
         width=8.5, height=11, 
         units=c("in"), dpi=400)
  ggsave("Capofari_HW_1.2.jpg", plot=q, scale=1, 
         width=8.5, height=11, 
         units=c("in"), dpi=400)
  ggsave("Capofari_HW_1.3.jpg", plot=r, scale=1, 
         width=8.5, height=11, 
         units=c("in"), dpi=400)
}
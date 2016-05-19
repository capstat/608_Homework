library(ggplot2)
library(maps)
library(dplyr)

all_states = map_data("state")
my_states = c("south carolina", "north carolina", "virginia", 
              "maryland","delaware","pennsylvania", 
              "new jersey", "new york")
states = filter(all_states, region %in% my_states)

homes = c(34.014139, -81.044857,
          38.034404, -78.491326,
          36.938614, -76.319839,
          38.929075, -76.732230,
          41.390807, -73.962063,
          40.618058, -74.139493)

p = 
  ggplot() + 
  geom_polygon(data = states, 
               aes(x = long, y = lat, fill = region, group = group), 
               color = "mintcream") + 
  coord_fixed(1.3) +
  guides(fill=FALSE) + 
  theme_void() +
  geom_path(aes(x=homes[seq(2,12,2)], y=homes[seq(1,12,2)]), 
            color="darkblue", size=3, lineend="round") + 
  geom_point(aes(x=homes[seq(2,12,2)], y=homes[seq(1,12,2)]), 
             color="red", size=4) +
  annotate("text", y=42.6, x=-78, size=8, color="red",
           label="My First 12 Years", fontface="bold.italic")

png("homes.png", width=4, height=4, units='in', res=800, bg="transparent")
plot(p) 
dev.off()
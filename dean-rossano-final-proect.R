# load the required packages

library(tidyverse)
library(raster)          #raster()
library(sf)              #st_read()
library(ggspatial)       #annotation_scale,annotation_north_arrow
library(ggnewscale)      #new_scale_color() 
library(ggsn)            #scalebar()
library(shiny)           #Shiny app
library(plotly)          #plot_ly()
library(gridExtra)       #grid.arrange()

# set the working directory
# setwd("~/cs-masters/2024/spring/dsci-605/dsci-605-final-project/data")

# read the data
unemploy_rate <- read_csv("data/unemployment_county.csv")

crime_rate <- read_csv("data/crime_and_incarceration_by_state.csv")

states <- st_read("data/tl_2019_us_state/tl_2019_us_state.shp")

##  filter the data to the contiguous states
contiguous_states <- states%>% filter(STUSPS!="AK"& 
                                       STUSPS!="AS"& 
                                       STUSPS!="MP"& 
                                       STUSPS!="PR"& 
                                       STUSPS!="VI"& 
                                       STUSPS!="HI"& 
                                       STUSPS!="GU")

# check that the length is 49 ie; 49 states

length(unique(contiguous_states$STUSPS))

## process the unenmployment rate data

# check if the amount of states is 49
unique(unemploy_rate $State)
length(unique(unemploy_rate $State))
# returns 50

# filter out HI and AK and group by year and state

unemploy_rate <-  unemploy_rate %>% filter(State!="AK"& State!="HI") %>%
  group_by(State,Year) %>% 
   summarise(Totalforce=sum(`Labor Force`),
             Totalemployed=sum(Employed),
             Totalunemployed=sum(Unemployed),
             Meanrate=mean(`Unemployment Rate`,rm.na=TRUE)
  )

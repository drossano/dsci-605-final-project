# load the required packages

library(tidyverse)
library(raster)          #raster()
library(sf)              #st_read()
library(ggspatial)       #annotation_scale,annotation_north_arrow
library(ggnewscale)      #new_scale_color() 
# library(ggsn)            #scalebar()
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
             unemp_rate=mean(`Unemployment Rate`,rm.na=TRUE)
  )
# check the amount of states again
length(unique(unemploy_rate $State))
# returns 48

# change State column name to STSUSPS and filter to years from 2007 to 2014
unemploy_rate <- unemploy_rate %>% 
  rename("STUSPS"="State") %>% 
  filter(Year %in% c(2007:2014))

## process the crime rate data

#check the amount of states
length(unique(crime_rate$jurisdiction))

# returns 51
head(crime_rate)


# change the column names and filter out FEDERAL, ALASKA & HAWAII
crime_rate <-  crime_rate %>% 
  rename("STUSPS"="jurisdiction") %>% 
  rename("Year"="year") %>% 
  filter(STUSPS!="FEDERAL"& STUSPS!="ALASKA"& STUSPS!="HAWAII") %>% #library(stringr)
  filter(Year %in% c(2007:2014))

##Recheck the data
length(unique(crime_rate$STUSPS))

head(crime_rate)

# change the state names in the state column "STUSPS"
crime_rate$STUSPS <- state.abb[match(str_to_title(crime_rate$STUSPS),state.name)]
# calculate the crimerate
crime_rate <-crime_rate %>% 
  mutate(crime_rate=(violent_crime_total/state_population)*100) %>% 
  dplyr::mutate_if(is.numeric, round, 1)

# join state data with unemployment data
state_unemp = right_join(contiguous_states, unemploy_rate, by = c("STUSPS"))

# join crime data with unemployment/state data
state_crime_unemp = right_join(state_unemp,crime_rate,by = c("Year", "STUSPS"))

# select columns
state_crime_unemp = state_crime_unemp[c("REGION","STUSPS","NAME","Year","unemp_rate","crime_rate")]

# export data
saveRDS(state_crime_unemp, "~/cs-masters/2024/spring/dsci-605/dsci-605-final-project/state_crime_unemp.rds")

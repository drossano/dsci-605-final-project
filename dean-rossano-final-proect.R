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
unemploy_rate <- read.csv("data/unemployment_county.csv")

crime_rate <- read.csv("data/crime_and_incarceration_by_state.csv")

states <- st_read("data/tl_2019_us_state/tl_2019_us_state.shp")

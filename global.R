# Load Libraries

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidytext)
library(tidyverse)

# Load Data
bigram_data<-read_csv("appData/bigram_data.csv", col_names=T)
trigram_data<-read_csv("appData/trigram_data.csv", col_names=T)
quadrigram_data<-read_csv("appData/quadrigram_data.csv", col_names=T)


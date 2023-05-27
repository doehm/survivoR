library(shiny)
library(lubridate)
library(stringr)
library(readr)
library(glue)
library(dplyr)

uiid <- paste0("x", str_pad(1:24, side = "left", width = 2, pad = 0))
confApp <- new.env()
confApp$default_path <- "confessional-timing"
confApp$start_season <- max(survivoR::season_summary$season)

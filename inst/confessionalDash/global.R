library(shiny)
library(lubridate)
library(stringr)
library(readr)
library(glue)
library(dplyr)
library(purrr)

uiid <- paste0("x", str_pad(1:24, side = "left", width = 2, pad = 0))
confApp <- new.env()
confApp$default_path <- "confessional timing"

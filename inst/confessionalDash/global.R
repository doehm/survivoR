library(shiny)
library(lubridate)
library(stringr)
library(readr)
library(glue)
library(dplyr)
library(purrr)
library(crayon)

uiid <- paste0("x", str_pad(1:24, side = "left", width = 2, pad = 0))


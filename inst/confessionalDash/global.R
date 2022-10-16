library(shiny)
library(lubridate)
library(stringr)
library(readr)
library(glue)
library(dplyr)
library(purrr)

uiid <- paste0("x", str_pad(1:24, side = "left", width = 2, pad = 0))

if(!exists("confApp")) {
  env_file <- file.path(system.file(package = "survivoR"), "confessionalDash/env.rda")
  if(file.exists(env_file)) {
    load(env_file)
  } else {
    confApp <- new.env()
    confApp$default_path <- ""
  }
}


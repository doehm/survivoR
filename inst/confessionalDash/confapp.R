#' Launch Confessional App
#'
#' Opens a viewer or browser to time castaway confessionals
#'
#' @param browser Open in browser instead of viewer. Logical.
#'
#' @return Shiny app
#' @export
launch_confessional_app <- function(browser = FALSE) {
  shiny::runApp(file.path(system.file(package = "survivoR"), "confessionalDash"))
}

#' Set the default path
#'
#' Sets the default path of the output files for the confessional app
#'
#' @param path The desired default path
#'
#' @return Nothing
#' @export
set_default_path <- function(path) {
  if(!exists("confApp")) {
    confApp <- new.env()
  }
  confApp$default_path <- path
  save(confApp,file = paste0(system.file(package = "survivoR"), "/confessionalDash/env.rda"))
  cat(crayon::green("Confessional App default path saved\n"))
}

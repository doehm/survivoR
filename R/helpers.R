
#' Show a season logo palette
#'
#' Easily view a palette for a given season and version including the log for reference
#'
#' @param version_season The version / season key e.g. `US42`
#' @param type Either `logo` or `tribe`. Currently only for `logo`
#' @param n The number of colours to view in the palette
#'
#' @return A ggplot2 graphic with the palette and logo
#' @export
#'
#' @importFrom glue glue
#' @importFrom prismatic color
#'
#' @examples
#'
#' show_palette("US43", n = 6)
show_palette <- function(version_season, n = NULL, type = "logo") {

  pal <- survivoR::season_palettes$palette[survivoR::season_palettes$version_season == version_season]
  if(length(pal) == 0) stop(glue("No logo for {version_season}\n"))

  if(is.null(n)) {
    n <- length(pal)
  } else {
    pal <- colorRampPalette(pal)(n)
  }

  x1 <- seq(0, 1-1/n, 1/n)
  x2 <- x1 + 1/n

  print(prismatic::color(pal))
  cat("\nCopy paste \u2192 ", paste0("c('", paste0(pal, collapse = "', '"), "')\n"))

  ggplot(tibble(x1, x2)) +
    geom_rect(aes(xmin = x1, xmax = x2, ymin = 0, ymax = 1), fill = pal) +
    ggpath::geom_from_path(aes(0.5, 0.5, path = glue::glue("https://gradientdescending.com/survivor/logos-clean/{version_season}.png")), width = 0.45) +
    theme_void()

}


#' Castaway images
#'
#' Returns the URL for the image of the specified castaways by their `castaway_id`
#' and season / version they were in
#'
#' @param castaway_ids Castaway ID
#' @param version_season Version season key for the season they played
#'
#' @return Character vector of URLs
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#'
#' survivoR::castaways %>%
#' filter(version_season == "US42") %>%
#'   mutate(
#'     castaway_image = get_castaway_image(castaway_id, version_season),
#'     castaway_image_cricle = cropcircles::circle_crop(castaway_image)
#'   ) %>%
#'   ggplot(aes(order, age)) +
#'   ggpath::geom_from_path(aes(path = castaway_image_cricle), width = 0.05) +
#'   ylim(0, NA)
#'
get_castaway_image <- function(castaway_ids, version_season) {
  glue::glue("https://gradientdescending.com/survivor/castaways/colour/{version_season}{castaway_ids}.png")
}


#' Check package version
#'
#' Compares the Github version to the system version currently loaded.
#' The user will be informed if more up to date data exists on Github
#'
#' @return A message
#' @export
#'
#' @importFrom utils packageVersion read.table
#'
#' @examples
#' check_version()
check_version <- function() {
  tryCatch(
    {
      git_version <- suppressWarnings(read.table("https://raw.githubusercontent.com/doehm/survivoR/master/inst/version-git.txt")[1,1])
      git <- as.numeric(strsplit(git_version, "\\.")[[1]])
      sys_version <- as.character(utils::packageVersion("survivoR"))
      sys <- as.numeric(strsplit(sys_version, "\\.")[[1]])
      if(any(git - sys > 0)) {
        msg1 <- paste0("Package version on Git (", git_version, ") is ahead of system version (", sys_version, ")\n")
        msg2 <- "Install from Git for the latest data - devtools::install_github('doehm/survivoR')"
        message(paste0(msg1, msg2))
      } else {
        message("Up to date")
      }
    },
    error = function(e) message("Head to https://github.com/doehm/survivoR to check for the latest data")
  )
}

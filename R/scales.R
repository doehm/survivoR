#' Survivor palette
#'
#' To create scale functions for ggplot. Given a season of Survivor, a palette
#' is created from the tribe colours for that season including the merged tribe.
#'
#' @param season Season number
#' @param scale_type Discrete or continuous. Input \code{d} or \code{c}.
#' @param reverse Logical. Reverse the palette?
#' @param tribe Tribe names. Default \code{NULL}
#' @param ... Other arguments passed on to methods.
#'
#' @details If it is intended the colours will correspond to the tribes e.g. a stacked bar chart
#' of votes given to each finalist and the colour corresponds to their original tribe (as in the
#' example below), the tribe vector needs to be passed to the scale function (for now). If no
#' tribe vector is given it will simply treat the tribe colours as a colour palette.
#'
#' @return Scale functions for ggplot2
#' @export
#'
#' @import ggplot2
#' @importFrom stringr str_sub
#' @importFrom grDevices colorRampPalette
#'
#' @rdname scales_survivor
#'
#' @examples \dontrun{
#' ssn <- 35
#' labels <- castaways %>%
#'   filter(
#'     season == ssn,
#'     str_detect(result, "Sole|unner")
#'   ) %>%
#'   select(castaway, original_tribe) %>%
#'   mutate(label = glue("{castaway} ({original_tribe})")) %>%
#'   select(label, castaway)
#' jury_votes %>%
#'   filter(season == ssn) %>%
#'   left_join(
#'     castaways %>%
#'       filter(season == ssn) %>%
#'       select(castaway, original_tribe),
#'     by = "castaway"
#'   ) %>%
#'   group_by(finalist, original_tribe) %>%
#'   summarise(votes = sum(vote)) %>%
#'   left_join(labels, by = c("finalist" = "castaway")) %>% {
#'     ggplot(., aes(x = label, y = votes, fill = original_tribe)) +
#'       geom_bar(stat = "identity", width = 0.5) +
#'       scale_fill_survivor(ssn, tribe = .$original_tribe) +
#'       theme_minimal() +
#'       labs(
#'         x = "Finalist (original tribe)",
#'         y = "Votes",
#'         fill = "Original\ntribe",
#'         title = "Votes received by each finalist"
#'       )
#'  }
#'  }
survivor_pal <- function(season, scale_type = "d", reverse = FALSE, tribe = NULL, ...) {
  cols <- sort(season_palette(season), decreasing = TRUE)
  if(reverse) cols <- rev(cols)
  switch(
    str_sub(scale_type, 1, 1),
    d = function(n) {
      if(n > length(cols)){
        colorRampPalette(cols)(n)
      }else{
        if(!is.null(tribe)) {
          tribes <- unique(tribe)
          cols <- survivoR::tribe_colours$tribe_colour
          names(cols) <- survivoR::tribe_colours$tribe
          unname(cols[tribes])
        }else {
          cols[1:n]
        }
      }
    },
    c = function(n) {
      colorRampPalette(cols[1:3])(200)[floor(n*199)+1]
    }
  )
}

#' Survivor fill aesthetic
#'
#' @param season Season number
#' @param scale_type Discrete or continuous. Input \code{d} or \code{c}.
#' @param reverse Logical. Reverse the palette?
#' @param ... Other arguments passed on to methods.
#'
#' @rdname scales_survivor
#'
#' @return
#' @export
scale_fill_survivor <- function(season, scale_type = "d", reverse = FALSE, ...) {
 switch(
   str_sub(scale_type, 1, 1),
   d = ggplot2::discrete_scale("fill", "survivor", survivor_pal(season, scale_type, reverse = reverse, ...)),
   c = ggplot2::continuous_scale("fill", "survivor", survivor_pal(season, scale_type, reverse = reverse, ...), guide = "colorbar", ...)
 )
}

#' Scale colour aesthetic
#'
#' @param season Season number
#' @param scale_type Discrete or continuous.  Input \code{d} or \code{c}.
#' @param reverse Logical. Reverse the palette?
#' @param ... Other arguments passed on to methods.
#'
#' @rdname scales_survivor
#'
#' @return
#' @export
scale_colour_survivor <- function(season, scale_type = "d", reverse = FALSE, ...) {
  switch(
    str_sub(scale_type, 1, 1),
    d = ggplot2::discrete_scale("colour", "survivor", survivor_pal(season, scale_type, reverse = reverse, ...)),
    c = ggplot2::continuous_scale("colour", "survivor", survivor_pal(season, scale_type, reverse = reverse, ...), guide = "colorbar", ...)
  )
}

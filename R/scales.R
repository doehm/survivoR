#' Survivor palette
#'
#' To create scale functions for ggplot. Given a season of Survivor, a palette
#' is created from the tribe colours for that season including the merged tribe.
#'
#' @param season blah
#' @param scale_type blah
#' @param reverse blah
#' @param ... dots
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
#' season_summary %>%
#'   select(season, viewers_premier, viewers_finale, viewers_reunion, viewers_mean) %>%
#'   pivot_longer(cols = -season, names_to = "episode", values_to = "viewers") %>%
#'   mutate(
#'     episode = to_title_case(str_replace(episode, "viewers_", ""))
#'   ) %>%
#'   ggplot(aes(x = season, y = viewers, colour = episode)) +
#'   geom_line() +
#'   geom_point(size = 2) +
#'   theme_minimal() +
#'   scale_colour_survivor(16)
#'  }
survivor_pal <- function(season, scale_type = "d", reverse = FALSE, tribe = NULL, ...) {
  ssn <- season
  cols <- sort(unique(survivoR::tribe_colours$tribe_colour[survivoR::tribe_colours$season == ssn]), decreasing = TRUE)
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
#' @param scale_type Discrete or continuous. Input 'd' / 'c'.
#' @param reverse Logical. Reverse the palette?
#' @param ... Dots
#'
#' @rdname scales_survivor
#'
#' @return
#' @export
scale_fill_survivor <- function(season, scale_type = "d", reverse = FALSE, ...) {
 switch(
   str_sub(scale_type, 1, 1),
   d = ggplot2::discrete_scale("fill", "evo", survivor_pal(season, scale_type, reverse = reverse, ...)),
   c = ggplot2::continuous_scale("fill", "evo", survivor_pal(season, scale_type, reverse = reverse, ...), guide = "colorbar", ...)
 )
}

#' Scale colour aesthetic
#'
#' @param season Season number
#' @param scale_type Discrete or continuous. Input 'd' / 'c'.
#' @param reverse Logical. Reverse the palette?
#' @param ... Dots
#'
#' @rdname scales_survivor
#'
#' @return
#' @export
scale_colour_survivor <- function(season, scale_type = "d", reverse = FALSE, ...) {
  switch(
    str_sub(scale_type, 1, 1),
    d = ggplot2::discrete_scale("colour", "evo", survivor_pal(season, scale_type, reverse = reverse, ...)),
    c = ggplot2::continuous_scale("colour", "evo", survivor_pal(season, scale_type, reverse = reverse, ...), guide = "colorbar", ...)
  )
}

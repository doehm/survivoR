
#' Adds alive flag
#'
#' Adds a logical flag if the castaway is alive at the start or end of an episode
#'
#' @param df Data frame. Must contain `version_season` and `castaway`.
#' @param .ep Episode to evaluate the flag.
#' @param .at Either 'start' or 'end'. If 'start' the flag will indicate who is
#' alive at the start of the episode. If 'end' it will indicate who is alive at
#' the end of the episode i.e. after tribal council.
#'
#' @return A data frame with a new column `alive`.
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' df <- confessionals |>
#'   filter_us(47) |>
#'   add_alive(12)
#'
#' df |>
#'   filter(alive) |>
#'   group_by(castaway) |>
#'   summarise(n = sum(confessional_count))
add_alive <- function(df, .ep, .at = "end") {

  vs_ls <- unique(df$version_season)

  df_alive <- map_dfr(vs_ls, function(vs) {

    alive <- still_alive(vs, .ep = .ep, .at = .at)

    get_cast(vs) |>
      distinct(version_season, castaway) |>
      mutate(alive = castaway %in% alive$castaway)

  })

  df |>
    inner_join(
      df_alive,
      join_by(version_season, castaway)
    )

}


#' Add winner
#'
#' Adds a winner flag to the data set.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`.
#'
#' @export
#' @return A data frame with a logical flag for the winner
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   add_winner()
#'
add_winner <- function(df) {

  df |>
    left_join(
      survivoR::castaways |>
        group_by(version_season, castaway_id) |>
        summarise(winner = any(winner)) |>
        ungroup(),
      join_by(version_season, castaway_id)
    )

}



#' Add jury member
#'
#' Adds a jury member flag to the data set.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`.
#'
#' @export
#' @return A data frame with a logical flag for the jury members
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   add_jury()
#'
add_jury <- function(df) {

  df_jury <- survivoR::castaways |>
    filter(!is.na(place)) |>
    distinct(version_season, castaway, jury)

  df |>
    left_join(
      df_jury,
      join_by(version_season, castaway)
    )

}


#' Add winner
#'
#' Adds a winner flag to the data set.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`.
#'
#' @export
#' @return A data frame with a logical flag for the winner
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   add_winner()
#'
add_finalist <- function(df) {

  df_finalist <- survivoR::castaways |>
    filter(!is.na(place)) |>
    distinct(version_season, castaway, finalist)

  df |>
    left_join(
      df_finalist,
      join_by(version_season, castaway)
    )

}


#' Add castaway
#'
#' Adds `castaway` to a data frame. Input data frame must have `castaway_id`.
#'
#' @param df Data frame. Requires `castaway_id`.
#'
#' @return Data frame with `castaway`.
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' df_no_castaway <- confessionals |>
#'   filter_us(47) |>
#'   group_by(castaway_id) |>
#'   summarise(n = sum(confessional_count))
#'
#' df_no_castaway |>
#'   add_castaway()
#'
add_castaway <- function(df) {

  df |>
    left_join(
      survivoR::boot_mapping |>
        filter(order == 0) |>
        distinct(castaway_id, castaway) |>
        group_by(castaway_id) |>
        slice(1),
      join_by(castaway_id)
    ) |>
    select(castaway_id, castaway, everything())

}


#' Add demographics
#'
#' Add demographics that includes age, gender, race/ethnicity, and lgbtqia+
#' status to a data frame with `castaway_id`.
#'
#' @param df Data frame. Requires `castaway_id`.
#'
#' @return Data frame with castaway added to it.
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_demogs()
#'
add_demogs <- function(df) {

  df |>
    left_join(
      survivoR::castaway_details |>
        select(castaway_id, gender, bipoc, latin = latin_american, black = african, asian),
      by = join_by(castaway_id)
    ) |>
    add_lgbt()

}

#' Add tribe
#'
#' Adds tribe to a data frame for a specified stage of the game e.g. original,
#' swapped, swapped_2, etc.
#'
#' @param df Data frame. Requires `version_season` and `castaway_id`,
#' @param .tribe_status Tribe status e.g. original, swapped, swapped_2, etc.
#'
#' @return Data frame with `tribe` added.
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' confessionals |>
#'   add_tribe()
#'
add_tribe <- function(df, .tribe_status = "Original") {

  if(is.null(.tribe_status)) {
    out <- df |>
      left_join(
        survivoR::tribe_mapping |>
          distinct(version_season, episode, castaway_id, tribe),
        by = c("version_season", "episode", "castaway_id")
      )
  } else {
    out <- df |>
      left_join(
        survivoR::tribe_mapping |>
          filter(tribe_status == .tribe_status) |>
          distinct(version_season, castaway_id, tribe),
        by = c("version_season", "castaway_id")
      )
  }
  out
}


#' Add tribe colour
#'
#' Add tribe colour to the data frame. Useful for preparing the data for
#' plotting with ggplot2.
#'
#' @param df Data frame. Requires `version_season` and `tribe`.
#' @param .tribe_status Tribe status e.g. original, swapped, swapped_2, etc.
#'
#' @return Data frame with `tribe_colour` added
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_tribe() |>
#'   add_tribe_colour()
#'
add_tribe_colour <- function(df, .tribe_status = "Original") {

  tribe_cols <- survivoR::tribe_colours |>
    filter(tribe_status == .tribe_status) |>
    distinct(version_season, tribe, tribe_colour)

  df_bm <- survivoR::boot_mapping |>
    filter(tribe_status == .tribe_status) |>
    distinct(version_season, castaway, tribe)

  df_cast <- df |>
    ungroup() |>
    distinct(version_season, castaway) |>
    left_join(df_bm, join_by(version_season, castaway)) |>
    distinct(version_season, castaway, tribe) |>
    left_join(tribe_cols, join_by(version_season, tribe)) |>
    select(-tribe)

  df |>
    left_join(df_cast, join_by(version_season, castaway))
}


#' Add gender
#'
#' Adds gender to a data frame
#'
#' @param df Data frame. Requires `castaway_id`.
#'
#' @return Data frame with gender added to it.
#' @export
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_gender()
#'
add_gender <- function(df){
  df |>
    left_join(
      survivoR::castaway_details |>
        select(castaway_id, gender),
      by = "castaway_id"
    )
}


#' Add full name
#'
#' Adds full name to the data frame. Useful for plotting and making tables.
#'
#' @param df Data frame. Requires `castaway_id`.
#'
#' @export
#' @return Data frame with full name.
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_full_name()
#'
add_full_name <- function(df) {
  df |>
    left_join(
      survivoR::castaway_details |>
        select(castaway_id, full_name_detailed),
      by = "castaway_id"
    )
}


#' Adds BIPOC
#'
#' Adds a BIPOC to the data frame. If any African American, Asian American,
#' Latin American, or Native American is `TRUE` then BIPOC is `TRUE`.
#'
#' @param df Data frame. Requires `castaway_id`.
#'
#' @export
#' @return Data frame with BIPOC added.
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_bipoc()
#'
add_bipoc <- function(df) {
  df |>
    left_join(
      survivoR::castaway_details |>
        select(castaway_id, bipoc),
      join_by(castaway_id)
    )
}

#' Add result
#'
#' Adds the result and place to the data frame.
#'
#' @param df Data frame. Requires `castaway_id` and `version_season`.
#'
#' @export
#' @return Data frame with result and place added.
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_result()
#'
add_result <- function(df) {

  df |>
    left_join(
      survivoR::castaways |>
        distinct(version_season, castaway_id, result, place, order) |>
        group_by(version_season, castaway_id) |>
        slice_max(order) |>
        select(-order),
      join_by(version_season, castaway_id)
    )

}

#' Add LGBTQIA+ status
#'
#' Adds the LGBTQIA+ flag to the data frame.
#'
#' @param df Data frame. Requires `castaway_id` and `version_season`.
#'
#' @export
#' @return Data frame with the LGBTQIA+ flag added.
#'
#' @examples
#'
#' library(survivoR)
#' library(dplyr)
#'
#' get_cast("US47") |>
#'   add_lgbt()
#'
add_lgbt <- function(df) {

  df |>
    left_join(
      survivoR::castaway_details |>
        select(castaway_id, lgbt),
      join_by(castaway_id)
    )

}

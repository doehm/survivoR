# survivor

# TODO: put on who had individual immunity, who played hidden immunity idol, who for and which votes were nullified
# TODO: nicknames
# TODO: tribe colours

#' Cleans all data sets
#'
#' Calls all scripts, cleans data for all seasons and binds data frames for package
#'
#' @param folders Folders of datasets to clean
#' @param source_loc Location of scripts to source
#'
#' @return
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import stringr
#' @importFrom logger log_info
#' @importFrom crayon green
#' @importFrom snakecase to_parsed_case
#' @importFrom glue glue
#' @importFrom readr read_rds
#' @importFrom janitor clean_names
#'
#' @examples \dontrun{}
clean_all <- function(
  folders = c("immunity", "jury-votes", "rewards", "season-cast", "viewers", "vote-history"),
  source_loc = "dev/harvest"
) {
  log_info(green("reading in raw html data"))
  raw <- read_rds("dev/webpages/raw-html-data.rds")
  seasons <- list.files(source_loc, full.names = TRUE)
  for(season_k in seasons) {
    log_info(glue(green("cleaning {season_k}")))
    source(season_k)
  }

  # assign isn't working so writing it out explicitly
  log_info(green("binding"))
  log_info(glue(green("... immunity")))
  immunity <- map_dfr(list.files(glue("dev/immunity"), full.names = TRUE), read_rds)
  save(immunity, file = glue("data/immunity.rda"))

  log_info(glue(green("... jury_votes")))
  jury_votes <- map_dfr(list.files(glue("dev/jury-votes"), full.names = TRUE), read_rds)
  save(jury_votes, file = glue("data/jury-votes.rda"))

  log_info(glue(green("... rewards")))
  rewards <- map_dfr(list.files(glue("dev/rewards"), full.names = TRUE), read_rds)
  save(rewards, file = glue("data/rewards.rda"))

  log_info(glue(green("... season-cast")))
  season_cast <- map_dfr(list.files(glue("dev/season-cast"), full.names = TRUE), read_rds)
  save(season_cast, file = glue("data/season-cast.rda"))

  log_info(glue(green("... viewers")))
  viewers <- map_dfr(list.files(glue("dev/viewers"), full.names = TRUE), read_rds)
  save(viewers, file = glue("data/viewers.rda"))

  log_info(glue(green("... vote-history")))
  vote_history <- map_dfr(list.files(glue("dev/vote-history"), full.names = TRUE), read_rds)
  save(vote_history, file = glue("data/vote-history.rda"))

  log_info(green("done"))
}


#' Read webpage
#'
#' Scrapes the Survivor wiki pages
#'
#' @param pages List of webpages
#' @param out_loc Output location
#'
#' @return
#' @export
#'
#' @importFrom xml2 read_html
#' @importFrom readr write_rds
#' @importFrom rvest html_nodes html_table
#'
#' @examples \dontrun{}
read_webpages <- function(
  pages,
  out_loc = "dev/webpages/raw-html-data.rds"
) {
  map(pages, function(page) {
    log_info(glue(green("reading {page}")))
    season_html <- read_html(page)
    tbls <- html_nodes(season_html, "table")
    dfs <- map(tbls, ~{
      tryCatch(html_table(.x, fill = TRUE), error = function(e) NULL)
    })
  }) %>%
  write_rds(out_loc)
  log_info(green("done"))
}


#' Title
#'
#' List of Wikipedia pages for each season
#'
#' @export
webpages <- list(
  season40 = "https://en.wikipedia.org/wiki/Survivor:_Winners_at_War",
  season39 = "https://en.wikipedia.org/wiki/Survivor:_Island_of_the_Idols",
  season38 = "https://en.wikipedia.org/wiki/Survivor:_Edge_of_Extinction",
  season37 = "https://en.wikipedia.org/wiki/Survivor:_David_vs._Goliath",
  season36 = "https://en.wikipedia.org/wiki/Survivor:_Ghost_Island",
  season35 = "https://en.wikipedia.org/wiki/Survivor:_Heroes_vs._Healers_vs._Hustlers",
  season34 = "https://en.wikipedia.org/wiki/Survivor:_Game_Changers",
  season33 = "https://en.wikipedia.org/wiki/Survivor:_Millennials_vs._Gen_X",
  season32 = "https://en.wikipedia.org/wiki/Survivor:_Ka%C3%B4h_R%C5%8Dng",
  season31 = "https://en.wikipedia.org/wiki/Survivor:_Cambodia",
  season30 = "https://en.wikipedia.org/wiki/Survivor:_Worlds_Apart",
  season29 = "https://en.wikipedia.org/wiki/Survivor:_San_Juan_del_Sur",
  season28 = "https://en.wikipedia.org/wiki/Survivor:_Cagayan",
  season27 = "https://en.wikipedia.org/wiki/Survivor:_Blood_vs._Water",
  season26 = "https://en.wikipedia.org/wiki/Survivor:_Caramoan",
  season25 = "https://en.wikipedia.org/wiki/Survivor:_Philippines",
  season24 = "https://en.wikipedia.org/wiki/Survivor:_One_World",
  season23 = "https://en.wikipedia.org/wiki/Survivor:_South_Pacific",
  season22 = "https://en.wikipedia.org/wiki/Survivor:_Redemption_Island",
  season21 = "https://en.wikipedia.org/wiki/Survivor:_Nicaragua",
  season20 = "https://en.wikipedia.org/wiki/Survivor:_Heroes_vs._Villains",
  season19 = "https://en.wikipedia.org/wiki/Survivor:_Samoa",
  season18 = "https://en.wikipedia.org/wiki/Survivor:_Tocantins",
  season17 = "https://en.wikipedia.org/wiki/Survivor:_Gabon",
  season16 = "https://en.wikipedia.org/wiki/Survivor:_Micronesia",
  season15 = "https://en.wikipedia.org/wiki/Survivor:_China",
  season14 = "https://en.wikipedia.org/wiki/Survivor:_Fiji",
  season13 = "https://en.wikipedia.org/wiki/Survivor:_Cook_Islands",
  season12 = "https://en.wikipedia.org/wiki/Survivor:_Panama",
  season11 = "https://en.wikipedia.org/wiki/Survivor:_Guatemala",
  season10 = "https://en.wikipedia.org/wiki/Survivor:_Palau",
  season9  = "https://en.wikipedia.org/wiki/Survivor:_Vanuatu",
  season8  = "https://en.wikipedia.org/wiki/Survivor:_All-Stars",
  season7  = "https://en.wikipedia.org/wiki/Survivor:_Pearl_Islands",
  season6  = "https://en.wikipedia.org/wiki/Survivor:_The_Amazon",
  season5  = "https://en.wikipedia.org/wiki/Survivor:_Thailand",
  season4  = "https://en.wikipedia.org/wiki/Survivor:_Marquesas",
  season3  = "https://en.wikipedia.org/wiki/Survivor:_Africa",
  season2  = "https://en.wikipedia.org/wiki/Survivor:_The_Australian_Outback",
  season1  = "https://en.wikipedia.org/wiki/Survivor:_Borneo"
)


#' Title
#'
#' List of Wikipedia pages for each season
#'
#' @export
raw <- read_rds("dev/webpages/raw-html-data.rds")

library(tidyverse)

in_code <- "castaway castaway_id confessional_count confessional_time
          episode exp_count exp_time index_count index_time season
          time_per_confessional version version_season"

in_docs <- "castaway castaway_id confessional_count confessional_time
          episode exp_count exp_time season version version_season"

in_code <- str_split_1(in_code, " ")
in_code <- in_code[in_code != ""]
in_code <- str_remove(in_code, "\n")

in_docs <- str_split_1(in_docs, " ")
in_docs <- in_docs[in_docs != ""]
in_docs <- str_remove(in_docs, "\n")

# in code not in docs
in_code[!in_code %in% in_docs]

# in docs not in code
in_docs[!in_docs %in% in_code]



# save tables
# write to excel
library(openxlsx)

hs <- createStyle(
  fontColour = "#ffffff", fgFill = "#2a9d8f",
  halign = "center", valign = "center", textDecoration = "Bold",
  border = "TopBottomLeftRight"
)

wb <- createWorkbook()
options("openxlsx.borderColour" = "#4F80BD")
options("openxlsx.borderStyle" = "thin")
modifyBaseFont(wb, fontSize = 10, fontName = "Arial Narrow")


castaways <- castaways %>%
  select(1:13, swapped_tribe, swapped_tribe2, merged_tribe, total_votes_received, immunity_idols_won)

data <- list(
  castaways = castaways,
  season_summary = season_summary,
  vote_history = vote_history,
  immunity = immunity %>% unnest(immunity),
  rewards = rewards %>% unnest(reward),
  viewers = viewers,
  jury_votes = jury_votes
)

iwalk(data, ~{
  addWorksheet(wb, sheetName = .y)
  char_cols <- map_lgl(castaways, is.character) %>%
    which()
  setColWidths(wb, sheet = .y, widths = 20, cols = char_cols)
  writeDataTable(wb, sheet = .y, x = .x, colNames = TRUE, rowNames = FALSE,
                 tableStyle = "TableStyleLight9", headerStyle = hs)
})

saveWorkbook(wb, "C:/Users/Dan/Documents/survivoR-docs/survivoR.xlsx", overwrite = TRUE)

fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("path", "Path", value = confApp$default_path),
      textInput("version", "Version", value = "US"),
      numericInput("season", "Season", value = confApp$start_season),
      numericInput("episode", "Episode", value = 1),
      actionButton("create_file", "Create file", icon = icon("file")),
      actionButton("refresh", "Refresh", icon = icon("rotate-right")),
      htmlOutput("madepath"),
      textAreaInput("notes", "Notes", "", rows = 12),
      actionButton("save_notes", "Save notes", icon = icon("save")),
      tags$button(
        id = "close",
        type = "button",
        class = "btn action-button",
        onclick = "setTimeout(function(){window.close();},500);",  # close browser
        "Close app"
      )
    ),
    mainPanel(
      includeCSS("www/styles.css"),
      fluidRow(
        column(
          6,
          tags$div(id = "placeholder1")
        ),
        column(
          6,
          tags$div(
            tags$link(href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@300&display=swap", rel="stylesheet"),
            id = "timestamps")
        )
      )
    )
  )
)

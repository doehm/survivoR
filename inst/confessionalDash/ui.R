fluidPage(
  includeCSS("www/styles.css"),
  sidebarLayout(
    sidebarPanel(
      HTML("<span class='title'>Confessional Timing App</span>"),
      textInput("path", "Path", value = confApp$default_path),
      selectInput("version", "Version", choices = c("US", "AU", "SA", "NZ"), selected = "US"),
      numericInput("season", "Season", value = confApp$start_season),
      numericInput("episode", "Episode", value = 1),
      actionButton("create_file", "Create file", icon = icon("file")),
      actionButton("refresh", "Refresh", icon = icon("rotate-right")),
      htmlOutput("madepath"),
      textAreaInput("notes", "Notes", "", rows = 6),
      actionButton("save_notes", "Save notes", icon = icon("save")),
      tags$button(
        id = "close",
        type = "button",
        class = "btn action-button",
        onclick = "setTimeout(function(){window.close();},500);",  # close browser
        "Close app"
      ),
      HTML("<br><br><strong>User guide</strong>"),
      HTML("<ol>
           <li>Select the version, season and episode</li>
           <li><strong>Click 'Create file'</strong> The castaways will be populated
           in the main panel ordered by tribe</li>
           <li>While watching the episode
           <ol>
           <li><strong>Click 'Start'</strong> when the castaway starts a confessionals. This includes
           if the confessionals starts as a voiceover prior to them sitting.</li>
           <li><strong>Click 'Stop'</strong> when they stop talking</li>
           <li>If you start the timer 2s late, stop the timer 2s after. Duration is what matters.</li>
           <li>If you stop the timer too late and need to make an adjustment, make a note in the
           notes section e.g. id 14 -5s (take 5s seconds off id 14). The notes is a free text field
           so you can write what you want. After the episode review the notes file and the 'Final'
           file and edit the data manually.</li>
           </ol>
           <li>When the episode finishes <strong>Click 'Close app'</strong></li>
           </ol>
           It's better to watch the epiosde in one sitting and either rewatch or make
           minor adjustments once the episode has episode has finished."),
      width = 3
    ),
    mainPanel(
      # there's a max of 4 tribes so 4 columns and placeholders
      fluidRow(
        column(
          3,
          tags$div(id = "tribe_name_1"),
          tags$div(id = "placeholder1")
        ),
        column(
          3,
          tags$div(id = "tribe_name_2"),
          tags$div(id = "placeholder2")
        ),
        column(
          3,
          tags$div(id = "tribe_name_3"),
          tags$div(id = "placeholder3")
        ),
        column(
          3,
          tags$div(id = "tribe_name_4"),
          tags$div(id = "placeholder4")
        ),
        column(
          3,
          tags$div(id = "log_hdr"),
          tags$div(
            tags$link(href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@300&display=swap", rel="stylesheet"),
            id = "timestamps")
        )
      )
    )
  )
)

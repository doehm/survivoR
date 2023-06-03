
# TODO: include a spinner once create_file is clicked

fluidPage(
  includeCSS("www/styles.css"),
  sidebarLayout(
    sidebarPanel(
      HTML("<span class='title'>Confessional Timing App</span>"),
      textInput("path", "Path", value = confApp$default_path),
      selectInput("version", "Version", choices = c("US", "AU", "SA", "NZ"), selected = "US"),
      numericInput("season", "Season", value = max(survivoR::season_summary$season)),
      numericInput("episode", "Episode", value = 1),
      actionButton("create_file", "Create file", icon = icon("file")),
      actionButton("refresh", "Refresh", icon = icon("rotate-right")),

      # can't work out how to make the spinner only spin when button is clicked and not at start-up.
      withSpinner(htmlOutput("madepath"), proxy.height = '80px'),

      textAreaInput("notes", "Notes", "", rows = 6),
      actionButton("save_notes", "Save notes", icon = icon("save")),
      actionButton("show_time", "Show times", icon = icon("stopwatch")),
      tags$button(
        id = "close",
        type = "button",
        class = "btn action-button",
        onclick = "setTimeout(function(){window.close();},500);",  # close browser
        "Close app"
      ),
      HTML("<br><br><u><strong>User guide</strong></u>"),
      HTML("<ol>
           <li>Select the version, season and episode</li>
           <li><strong>Click 'Create file'</strong>. The castaways will be populated
           in the main panel ordered by tribe</li>
           <li>While watching the episode:
           <ol>
           <li><strong>Click 'Start'</strong> when the castaway starts a confessionals. This includes
           if the confessional starts as a voice-over prior to them sitting.</li>
           <li><strong>Click 'Stop'</strong> when they stop talking.</li>
           <li>If you start the timer 2s late, stop the timer 2s after. Duration is what matters the most.</li>
           <li>If you stop the timer too late and need to make an adjustment, make a note in the
           notes section e.g. id 14 -5s (take 5s seconds off id 14). The notes is a free text field
           so you can write what you want. After the episode, review the notes in the 'Notes' file
           and edit the data manually in 'Final'.</li>
           </ol>
           <li><strong>When the episode finishes, click 'Show times'</strong>. A dialogue box will pop up
           where you can copy the table and paste into Excel of Google Sheets. You can check this throughout
           the session if desired.</li>
           <li><strong>Click 'Close app'</strong> to finish the session.</li>
           </ol>
           It's better to watch the epiosde in one sitting and either rewatch or make
           minor adjustments once the episode has episode has finished. Keep in mind that this is still
           a manual process and times will vary from person to person but should be a relatively small
           variation."),
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

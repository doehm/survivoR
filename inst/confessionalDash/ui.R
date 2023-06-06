
# TODO: include a spinner once create_file is clicked

fluidPage(
  includeCSS("www/styles.css"),
  sidebarLayout(
    sidebarPanel(
      HTML("<span class='title'>Confessional Timing App</span>"),
      textInput("path", "Path", value = confApp$default_path),
      fluidRow(
        column(4, selectInput("version", "Version", choices = c("US", "AU", "SA", "NZ", "UK"), selected = "US")),
        column(4, numericInput("season", "Season", value = max(survivoR::season_summary$season))),
        column(4, numericInput("episode", "Episode", value = 1))
      ),
      actionButton("create_file", HTML("&nbsp;Create file"), icon = icon("file")),
      actionButton("show_time", HTML("&nbsp;Show times"), icon = icon("stopwatch")),
      actionButton("refresh", HTML("&nbsp;Refresh page"), icon = icon("rotate-right")),
      actionButton("close", HTML("&nbsp;Close app"), class = "btn action-button", icon = icon("xmark"),
                   onclick = "setTimeout(function(){window.close();},500);"),

      # can't work out how to make the spinner only spin when button is clicked and not at start-up.
      withSpinner(htmlOutput("madepath"), proxy.height = '80px', type = 7),
      tags$div(id = "file_name"),

      HTML("<hr class='rounded'>"),
      HTML("<span class='subtitle'>Adjustments</span>"),
      fluidRow(
        column(6, numericInput("id_adj", label = "ID", value = 0)),
        # column(4, selectInput("action_adj", label = "Action", choices = c("start", "stop", "Remove"), selected = "stop")),
        # column(6, numericInput("value_adj", label = "Adjustment", value = 0)),
        column(6, selectInput("value_adj", label = "Adjustment", choices = c("Delete", -5:5))),
      ),
      actionButton("apply_adj", HTML("&nbsp;Apply Adjustment"), icon = icon("right-to-bracket")),
      HTML("<hr class='rounded'>"),
      textAreaInput("notes", span("Notes", class = "subtitle"), "", rows = 3),
      actionButton("save_notes", HTML("&nbsp;Save notes"), icon = icon("save")),
      shinyjs::useShinyjs(),
      shinyjs::extendShinyjs(text = "shinyjs.refresh_page = function() { location.reload(); }", functions = "refresh_page"),
      # HTML("<br><br><u><strong>User guide</strong></u>"),
      HTML("<hr class='rounded'>"),
      HTML("<span class='subtitle'>User guide</span>"),
      HTML("<ol>
           <li>Select the version, season and episode</li>
           <li><strong>Click 'Create file'</strong>. The castaways will be populated
           in the main panel ordered by tribe</li>
           <li>While watching the episode <strong>click 'Start'</strong> when the castaway starts a confessionals. This includes
           if the confessional starts as a voice-over prior to them sitting.</li>
           <li><strong>Click 'Stop'</strong> when they stop talking.</li>
           <li>If the timer is started 2s late, stop the timer 2s after. Duration is what matters the most.</li>
           <li>If the the timer is started too late and need to make an adjustment:</li>
           <ol>
           <li>Input the ID number, and the value adjustment e.g. -5. If the
           time stamp needs to be deleted, input the ID and select 'Delete'.</li>
           <li><strong>Click 'Apply adjustment'</strong>. Adjustments will be automatically applied
           and can be entered at any time.</li>
           </ol>
           <li><strong>When the episode finishes, click 'Show times'</strong>. A dialogue box will pop up
           where you can copy the table and paste into Excel of Google Sheets. You can check this throughout
           the session if desired.</li>
           <li><strong>Click 'Close app'</strong> to finish the session.</li>
           </ol>
           It's better to watch the epiosde in one sitting and either rewatch or make
           minor adjustments once the episode has episode has finished. For additional records you can
           record them in the <strong>'Notes'</strong> free text field."),
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

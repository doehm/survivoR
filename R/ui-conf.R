# confessional app UI function
conf_app_ui <- function() {
  fluidPage(
    includeCSS(file.path(system.file(package = "survivoR"), "www/styles.css")),
    HTML('<link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;700;900&display=swap" rel="stylesheet">'),
    sidebarLayout(
      sidebarPanel(
        HTML("<span class='title'>Confessional Timing</span>
             <img src='https://github.com/doehm/survivoR/blob/master/dev/images/hex-flame-final.png?raw=true' height='80px' align='right'>"),
        HTML("<br><i class='fa-brands fa-github'></i>&nbsp; Github: <a target='_blank' href='https://github.com/doehm/survivoR'>doehm/survivoR</a>"),
        textOutput("poll"),
        HTML("<hr class='rounded'>"),
        uiOutput("path_input"),
        uiOutput("file_selector"),
        fluidRow(
          column(4, selectInput("version", "Version", choices = c("US", "AU", "AW", "SA", "NZ", "UK"), selected = "US")),
          withSpinner(uiOutput("season_selector"), proxy.height = '40px', type = 7),
          uiOutput("episode_selector"),
        ),
        actionButton("create_file", HTML("&nbsp;Start"), icon = icon("play"), class = "this-button"),
        # actionButton("load_file", HTML("&nbsp;Load"), icon = icon("load"), class = "this-button"),
        actionButton("show_time", HTML("&nbsp;Show counts"), icon = icon("stopwatch-20")),
        actionButton("refresh", HTML("&nbsp;Refresh page"), icon = icon("rotate-right")),
        actionButton("close", HTML("&nbsp;Close app"), class = "btn action-button", icon = icon("xmark")),
        tags$div(id = "file_name"),
        HTML("<hr class='rounded'>"),
        HTML("<span class='subtitle'>Adjustments</span>"),
        fluidRow(
          column(4, numericInput("id_adj", label = "ID", value = 1, min = 1)),
          column(4, selectInput("value_adj", label = "Adjustment", choices = c("Delete", "Change castaway", c(-10, -7, -5:5, 7, 10)))),
          column(4, uiOutput("castaway_adj"))
        ),
        actionButton("apply_adj", HTML("&nbsp;Apply Adjustment"), icon = icon("right-to-bracket")),
        HTML("<hr class='rounded'>"),
        textAreaInput("notes", span("Notes", class = "subtitle"), "", rows = 3),
        uiOutput("save_notes_button"),
        shinyjs::useShinyjs(),
        shinyjs::extendShinyjs(text = "shinyjs.refresh_page = function() { location.reload(); }", functions = "refresh_page"),
        HTML("<hr class='rounded'>"),
        HTML("<span class='subtitle'>User guide</span>"),
        uiOutput("user_guide"),
        HTML("<br><i class='fa-solid fa-bug fa-rotate-90'></i>&nbsp; Please log issues or feature requests on
             <a target='_blank' href='https://github.com/doehm/survivoR/issues'>Github.</a>"),
        width = 3),
      mainPanel(
        fluidRow(
          column(
            2,
            tags$div(id = "tribe_name_1"),
            tags$div(id = "placeholder1")
          ),
          column(
            2,
            tags$div(id = "tribe_name_2"),
            tags$div(id = "placeholder2")
          ),
          column(
            2,
            tags$div(id = "tribe_name_3"),
            tags$div(id = "placeholder3")
          ),
          column(
            2,
            tags$div(id = "tribe_name_4"),
            tags$div(id = "placeholder4")
          ),
          column(
            4,
            tags$div(id = "log_hdr"),
            tags$div(
              tags$link(href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@300&display=swap", rel="stylesheet"),
              id = "timestamps")
          )
        )
      )
    )
  )
}

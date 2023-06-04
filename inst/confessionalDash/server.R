
# TODO: When start is clicked, but another start is clicked rather than the stop for the castaway
# either automatically time stamp stop first or block the other start time stamp.

function(input, output) {

  cfnl_id <- reactiveValues(k = 0)
  stamps <- reactiveValues(a = "")
  action <- reactiveValues(id = 0)


  # create file when button clicked -----------------------------------------

  # creates the file to write data to
  createFile <- eventReactive(input$create_file, {

    # check if it is a valid selection
    .season <- str_pad(input$season, side = "left", width = 2, pad = 0)
    .episode <- str_pad(input$episode, side = "left", width = 2, pad = 0)
    .time <- format(now(), "%Y-%m-%d %Hh%Mm%Ss")

    # check if valid selection
    valid_selections <- read_csv(
      "https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/valid-selections.csv",
      show_col_types = FALSE
      )

    selected <- valid_selections |>
      filter(
        version_season == paste0(input$version, .season),
        episode == input$episode
      )

    # TODO: Don't want this to actually fail rather alert and allow for another selection
    # or just dynamically update the input fields
    if(nrow(selected) == 0) stop("🛑🤚 Invalid selection")

    # create directories
    if(!dir.exists(input$path)) dir.create(input$path)
    if(!dir.exists(file.path(input$path, "Staging"))) dir.create(file.path(input$path, "Staging"))
    if(!dir.exists(file.path(input$path, "Notes"))) dir.create(file.path(input$path, "Notes"))
    if(!dir.exists(file.path(input$path, "Final"))) dir.create(file.path(input$path, "Final"))

    insertUI(
      selector = "#log_hdr",
      ui = h3("🪵 Log:", class="log", id = "log_hdr"),
    )

    # output list
    list(
      time = .time,
      file = paste0(.time, " ", input$version, .season, .episode, ".csv"),
      vs = paste0(input$version, .season),
      path = input$path,
      path_notes = file.path(input$path, "Notes", paste0(.time, " ", input$version, .season, .episode, ".txt")),
      path_staging = file.path(input$path, "Staging", paste0(.time, " ", input$version, .season, .episode, ".csv")),
      path_final = file.path(input$path, "Final", paste0(.time, " ", input$version, .season, .episode, ".csv"))
    )
  })

  # Renders the file path on the side panel
  output$madepath <- eventReactive(input$create_file, {

    renderText({
        paste0("File created:<br>", createFile()$file)
      })

  })

  observeEvent(input$create_file, {

    .vs <- createFile()$vs
    image_files <- paste0("www/castaways/", .vs, df()$cast$castaway_id, ".png")
    already_downloaded <- file.exists(image_files)
    if(any(!already_downloaded)) {
      cropcircles::circle_crop(
        survivoR::get_castaway_image(df()$cast$castaway_id[!already_downloaded], .vs),
        image_files[!already_downloaded],
        border_colour = df()$cast$tribe_colour,
        border_size = 4
      )
    }

  })

  # create data frame when create file clicked ------------------------------

  # make the castaway data frame
  # Note to self: do I need refresh here anymore?
  df <- eventReactive(any(input$refresh, input$create_file), {

    .vs <- createFile()$vs

    # TODO: create a workflow so that after each new episode the csv's are pushed to git.
    if(!.vs %in% survivoR::season_summary$version_season) {
      in_progress_vs <- readLines("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/vs.txt")
      online_file <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-boot-mapping.csv")
      online_file_tribe_colours <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-tribe-colours.csv")
      df_boot_mapping <- read_csv(online_file, show_col_types = FALSE)
      df_tribe_colours <- read_csv(online_file_tribe_colours, show_col_types = FALSE) |>
        distinct(version, version_season, season, tribe, tribe_colour)
    } else {
      df_boot_mapping <- survivoR::boot_mapping
      df_tribe_colours <- survivoR::tribe_colours
    }

    # make cast table
    df_cast <- df_boot_mapping |>
      filter(
        version == input$version,
        season == input$season,
        episode == input$episode
      ) |>
      group_by(version_season, castaway, castaway_id) |>
      slice_min(order) |>
      ungroup() |>
      distinct(version_season, castaway, castaway_id, tribe, tribe_status) |>
      left_join(
        df_boot_mapping |>
          filter(
            version == input$version,
            season == input$season,
            episode == 1
          ) |>
          group_by(version_season, castaway_id) |>
          slice_min(order) |>
          ungroup() |>
          distinct(version_season, castaway_id, original_tribe = tribe),
        by = c("version_season", "castaway_id")
      ) |>
      mutate(tribe = ifelse(tribe_status == "Merged", original_tribe, tribe)) |>
      arrange(tribe, castaway) |>
      mutate(
        uiid = paste0("x", str_pad(1:n(), side = "left", width = 2, pad = 0)),
        num = 1:n(),
        image = paste0("castaways/", version_season, castaway_id, ".png")
      ) |>
      left_join(
        df_tribe_colours |>
          filter(
            version == input$version,
            season == input$season
          ) |>
          distinct(version_season, tribe, tribe_colour),
        by = c("version_season", "tribe"))

    list(
      cast = df_cast,
      tribes = df_cast |>
        distinct(tribe, tribe_colour)
    )

  })

  # list of reactive elements -----------------------------------------------

  # a unique label for each castaway on the board
  lab_ls <- reactive({
    map(uiid, ~{
      list(
        name = paste0(df()$cast$num[df()$cast$uiid == .x], ". ", df()$cast$castaway[df()$cast$uiid == .x]),
        name0 = df()$cast$castaway[df()$cast$uiid == .x],
        action_start = paste0(.x, "Start"),
        action_stop = paste0(.x, "Stop"),
        duration = paste0(.x, "duration"),
        image = df()$cast$image[df()$cast$uiid == .x]
      )
    }) |>
      set_names(uiid)
  })

  # ts means time stamp
  ts <- map(uiid, ~reactiveValues(start = now(), stop = now(), duration = 0)) |>
    set_names(uiid)

  # remove UI on refresh ----------------------------------------------------

  observeEvent(input$refresh, {
    for(k in df()$cast$uiid) {
      removeUI(selector = "#booger")
    }

    for(k in unique(df()$cast$tribe)) {
      removeUI(selector = "#tribe_hdr")
    }

    removeUI(selector = "#log_hdr")

  })

  # creates the UI components -----------------------------------------------

  # e.g. buttons based on the number of castaways
  observeEvent(input$create_file, {

    ids <- df()$cast$uiid
    cols <- df()$cast$tribe_colour
    tribes <- df()$tribes$tribe
    tribe <- df()$cast$tribe
    tribe_cols <- df()$tribes$tribe_colour

    # tribe headers
    for(k in tribes) {
      insertUI(
        selector = paste0("#tribe_name_", which(tribes == k)),
        ui = tags$div(
          HTML(glue("<h2 class='hdr-bg' style='
                    background: {tribe_cols[which(tribes == k)]};
                    align='center'>{k}</h2>")),
          id = "tribe_hdr"
        )
      )
    }

    # castaways
    for(uiid in ids) {
      insertUI(
        selector = paste0("#placeholder", which(tribes == tribe[which(ids == uiid)])),
        ui = tags$div(
          fluidRow(
            br(),
            strong(HTML(glue("<center><span style='font-size:20px'>{lab_ls()[[uiid]]$name0}</span></center>"))),
            tags$img(src = lab_ls()[[uiid]]$image, height = 60),
            actionButton(paste0(uiid, "Start"), "Start"),
            actionButton(paste0(uiid, "Stop"), "Stop"),
            tags$head(
              tags$style(
                paste0("#", uiid, "duration", "{font-size: 32px; font-style: italic; font-weight: 700; }"),
                paste0("#", uiid, "Start", "{border-color: ", cols[which(ids == uiid)], "; border-width: 2px; border-radius: 20px}"),
                paste0("#", uiid, "Stop", "{border-color: ", cols[which(ids == uiid)], "; border-width: 2px; border-radius: 20px}"),
              )
            ),
            column(3, htmlOutput(paste0(uiid, "duration"))), # it's this htmlOutput that is blowing shit up but don't know why
            br()
          ),
          id = "booger"
        )
      )
    }
  })


  # observe button click and stamp time -------------------------------------

  # start
  lapply(
    uiid,
    function(.uiid) {
      observeEvent(input[[lab_ls()[[.uiid]]$action_start]], {
        cfnl_id$k <- cfnl_id$k + 1
        ts[[.uiid]]$start <- now()
        df_x <- data.frame(
          id = cfnl_id$k,
          castaway = df()$cast$castaway[df()$cast$uiid == .uiid],
          action = "start",
          time = as.character(ts[[.uiid]]$start)
        )
        write_csv(
          df_x,
          file = createFile()$path_staging,
          append = TRUE
        )

        action$id <- action$id + 1
        if(action$id > 30) {
          removeUI(
            selector = paste0("#", action$id-30)
          )
        }

        # insert time stamp in log
        insertUI(
          selector = "#timestamps",
          ui = tags$span(
            HTML(
              "<span class='stamp'>",
              cfnl_id$k,
              "<strong>",
              df()$cast$castaway[df()$cast$uiid == .uiid],
              "</strong><span class='stamp' style='color:red;'>start:</span>",
              format(ts[[.uiid]]$start, "%H:%M:%S"),
              "</span>",
              "<br>"
            ),
            id = action$id
          )
        )
      })
    }
  )


  # stop
  lapply(
    uiid,
    function(.uiid) {
      observeEvent(input[[lab_ls()[[.uiid]]$action_stop]], {
        ts[[.uiid]]$stop <- now()
        ts[[.uiid]]$duration <- ts[[.uiid]]$duration + round(as.numeric(ts[[.uiid]]$stop - ts[[.uiid]]$start))
        df_x <- data.frame(
          id = cfnl_id$k,
          castaway = df()$cast$castaway[df()$cast$uiid == .uiid],
          action = "stop",
          time = as.character(ts[[.uiid]]$stop)
        )
        write_csv(
          df_x,
          file = createFile()$path_staging,
          append = TRUE
        )

        action$id <- action$id + 1
        if(action$id > 24) {
          removeUI(
            selector = paste0("#", action$id-24)
          )
        }

        # insert time stamp in log
        insertUI(
          selector = "#timestamps",
          ui = tags$span(
            HTML(
              "<span class='stamp'>",
              cfnl_id$k,
              "<strong>",
              df()$cast$castaway[df()$cast$uiid == .uiid],
              "</strong>",
              "<span class='stamp' style='color:green;'>stop</span>:",
              format(ts[[.uiid]]$stop, "%H:%M:%S"),
              "</span>",
              "<br>"
            ),
            id = action$id
          )
        )
      })
    }
  )

  # Renders the duration to display on the dashy
  lapply(
    uiid,
    function(.uiid) {
      output[[paste0(.uiid, "duration")]] <- renderText({
        if(ts[[.uiid]]$start > ts[[.uiid]]$stop) {
          paste0("<span style='color:red;'>", round(ts[[.uiid]]$duration), "</span>")
        } else {
          ts[[.uiid]]$duration
        }
      })
    })

  # save notes to notes -----------------------------------------------------

  observeEvent(any(input$save_notes, input$close), {
    write_lines(input$notes, file = createFile()$path_notes)
  })

  df_conf_time <- eventReactive(input$show_time, {
     get_confessional_timing(
       paths = createFile()$path_staging,
       .vs = createFile()$vs,
       .episode = input$episode)
  })

  # popup to show the aggregated confessional times. ------------------------

  # TODO: would be good to have an open to download this directly to a csv/excel file
  observeEvent(input$show_time, {

    output$tbl_conf_timing <- renderDT({
      DT::datatable(
        df_conf_time(),
        rownames = FALSE,
        options = list(
          paging = FALSE
        )
      )
    })

    showModal(
      modalDialog(
        DTOutput("tbl_conf_timing"),
        footer = tagList(
          modalButton("Cancel")
        ),
        size = "l",
        easyClose = TRUE
      )
    )
  })

  observe({
    if (input$close > 0) {
      file.copy(createFile()$path_staging, createFile()$path_final)
      message(green(paste("\n\nData moved to:\n", createFile()$path_final)))
      message(green(glue("\n\nTo summarise the data run...\n\nget_confessional_timing(
  '{createFile()$path_final}',
  '{createFile()$vs}',
  {input$episode})\n")))
      rm(uiid, envir = .GlobalEnv)
      rm(confApp, envir = .GlobalEnv)
      stopApp() # stop shiny
    }
  })
}

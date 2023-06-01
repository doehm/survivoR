function(input, output) {

  cfnl_id <- reactiveValues(k = 0)
  stamps <- reactiveValues(a = "")
  action <- reactiveValues(id = 0)

  # creates the file to write data to
  createFile <- eventReactive(input$create_file, {
    .season <- str_pad(input$season, side = "left", width = 2, pad = 0)
    .episode <- str_pad(input$episode, side = "left", width = 2, pad = 0)
    .time <- format(now(), "%Y-%m-%d %Hh%Mm%Ss")

    # create directories
    if(!dir.exists(input$path)) {
      dir.create(input$path)
      dir.create(file.path(input$path, "Staging"))
      dir.create(file.path(input$path, "Notes"))
      dir.create(file.path(input$path, "Final"))
    }

    # output list
    list(
      time = .time,
      file = paste0(.time, " ", input$version, .season, .episode, ".csv"),
      path = input$path,
      path_notes = file.path(input$path, "Notes", paste0(.time, " ", input$version, .season, .episode, ".txt")),
      path_staging = file.path(input$path, "Staging", paste0(.time, " ", input$version, .season, .episode, ".csv")),
      path_final = file.path(input$path, "Final", paste0(.time, " ", input$version, .season, .episode, ".csv"))
    )
  })

  # when file created it builds the cast and lab lists
  observeEvent(input$create_file, {
    .vs <- paste0(input$version, str_pad(input$season, side = "left", width = 2, pad = 0))
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

  df <- eventReactive(any(input$refresh, input$create_file), {

    .vs <- paste0(input$version, str_pad(input$season, side = "left", width = 2, pad = 0))
    in_progress_vs <- readLines("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/vs.txt")

    if(.vs %in% in_progress_vs) {
      online_file <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}.csv")
      online_file_tribe_colours <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-tribe-colours.csv")
      df_boot_mapping <- read_csv(online_file, show_col_types = FALSE)
      df_tribe_colours <- read_csv(online_file_tribe_colours, show_col_types = FALSE) |>
        distinct(tribe, tribe_colour)
    } else {
      df_boot_mapping <- survivoR::boot_mapping
      df_tribe_colours <- survivoR::tribe_colours |>
        filter(tribe_status == "Original")
    }

    # filter boot mapping
    .tribe_status <- df_boot_mapping |>
      filter(
        version == input$version,
        season == input$season,
        episode == input$episode
      ) |>
      pull(tribe_status)

    .ep <- ifelse(.tribe_status[1] == "Merged", 1, input$episode)

    # make cast table
    df_cast <- df_boot_mapping |>
      filter(
        version == input$version,
        season == input$season,
        episode == input$episode
      ) |>
      distinct(version_season, castaway, castaway_id) |>
      left_join(
        df_boot_mapping |>
          filter(
            version == input$version,
            season == input$season,
            episode == .ep
          ) |>
          distinct(version_season, castaway_id, tribe),
        by = c("version_season", "castaway_id")
      ) |>
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
          ),
        by = "tribe")

    list(
      cast = df_cast,
      tribes = df_cast |>
        distinct(tribe, tribe_colour)
    )

  })

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

  ts <- map(uiid, ~reactiveValues(start = now(), stop = now(), duration = 0)) |>
    set_names(uiid)

  # creates the UI components e.g. buttons based on the number of castaways
  # remove UI on refresh
  observeEvent(input$refresh, {
    for(k in df()$cast$uiid) {
      removeUI(
        selector = "#booger"
      )
    }

    for(k in unique(df()$cast$tribe)) {
      removeUI(
        selector = "#tribe_hdr"
      )
    }

  })

  # build UI on create
  observeEvent(input$create_file, {
    ids <- df()$cast$uiid
    cols <- df()$cast$tribe_colour
    tribes <- df()$tribes$tribe
    tribe <- df()$cast$tribe
    tribe_cols <- df()$tribes$tribe_colour

    for(k in tribes) {
      insertUI(
        selector = paste0("#tribe_name_", which(tribes == k)),
        ui = tags$div(
          HTML(glue("<h2 class='hdr-bg' style='
                    color: {tribe_cols[which(tribes == k)]}'
                    align='center'>{k}</h2>")),
          id = "tribe_hdr"
        )
      )
    }

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
                paste0("#", uiid, "duration", "{font-size: 25px; font-style: italic; font-weight: 700; }"),
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

  # observe button click and stamp time
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
            selector = paste0("#", action$id-24)
          )
        }
        insertUI(
          selector = "#timestamps",
          ui = tags$span(
            HTML(
              "<span class='stamp'>",
              cfnl_id$k,
              "<strong>",
              df()$cast$castaway[df()$cast$uiid == .uiid],
              "</strong><span style='color:red;'>start</span>",
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
        insertUI(
          selector = "#timestamps",
          ui = tags$span(
            HTML(
              "<span class='stamp'>",
              cfnl_id$k,
              "<strong>",
              df()$cast$castaway[df()$cast$uiid == .uiid],
              "</strong>",
              "<span style='color:green;'>stop</span>, ",
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

  observeEvent(any(input$save_notes, input$close), {
    write_lines(input$notes, file = createFile()$path_notes)
  })

  # Renders the file path on the side panel
  output$madepath <- renderText({
    paste0("File created:<br>", createFile()$file)
  })

  observe({
    if (input$close > 0) {
      file.copy(createFile()$path_staging, createFile()$path_final)
      message(green(paste("\n\nData moved to:\n> ", createFile()$path_final)))
      message(green("Run get_confessional_timing() to summarise the data\n"))
      stopApp() # stop shiny
    }
  })
}

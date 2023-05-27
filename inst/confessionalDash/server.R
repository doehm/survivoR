function(input, output) {

  cfnl_id <- reactiveValues(k = 0)
  stamps <- reactiveValues(a = "")
  action <- reactiveValues(id = 0)

  # creates the file to write data to
  createFile <- eventReactive(input$create_file, {
    .season <- str_pad(input$season, side = "left", width = 2, pad = 0)
    .episode <- str_pad(input$episode, side = "left", width = 2, pad = 0)
    .time <- format(now(), "%Y-%m-%d %Hh%Mm%Ss")
    list(
      time = .time,
      file = paste0(.time, " ", input$version, .season, .episode, ".csv"),
      notes_path = file.path(input$path, "Notes", paste0(.time, " ", input$version, .season, .episode, ".txt")),
      path = file.path(input$path, "Staging", paste0(.time, " ", input$version, .season, .episode, ".csv")),
      path_final = file.path(input$path, "Final", paste0(.time, " ", input$version, .season, .episode, ".csv"))
      )
  })

  # when file created it builds the cast and lab lists
  observeEvent(input$create_file, {

    if(!dir.exists(input$path)) {
      dir.create(input$path)
      dir.create(file.path(input$path, "Staging"))
      dir.create(file.path(input$path, "Notes"))
      dir.create(file.path(input$path, "Final"))
    }

    .vs <- paste0(input$version, str_pad(input$season, side = "left", width = 2, pad = 0))
    image_files <- paste0("www/", .vs, df()$cast$castaway_id, ".png")
    already_downloaded <- file.exists(image_files)
    if(any(!already_downloaded)) {
      cropcircles::circle_crop(
        survivoR::get_castaway_image(df()$cast$castaway_id[!already_downloaded], .vs),
        image_files[!already_downloaded]
      )
    }
  })

  df <- eventReactive(any(input$refresh, input$create_file), {
    list(
      cast = survivoR::boot_mapping |>
        filter(
          version == input$version,
          season == input$season,
          episode == input$episode
        ) |>
        distinct(version_season, castaway, castaway_id, tribe) |>
        arrange(tribe, castaway) |>
        mutate(
          uiid = paste0("x", str_pad(1:n(), side = "left", width = 2, pad = 0)),
          num = 1:n(),
          image = paste0(version_season, castaway_id, ".png")
        )
    )

  })

  lab_ls <- reactive({
    map(uiid, ~{
      list(
        name = paste0(df()$cast$num[df()$cast$uiid == .x], ". ", df()$cast$castaway[df()$cast$uiid == .x]),
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
  })

  # build UI on create
  observeEvent(input$create_file, {
    for(uiid in df()$cast$uiid) {
      insertUI(
        selector = "#placeholder1",
        ui = tags$div(
          fluidRow(
            strong(HTML(lab_ls()[[uiid]]$name)),
            br(),
            tags$img(src = lab_ls()[[uiid]]$image, height = 40),
            column(
              4,
              htmlOutput(paste0(uiid, "duration"))
            ),
            actionButton(paste0(uiid, "Start"), "Start"),
            actionButton(paste0(uiid, "Stop"), "Stop"),
            tags$head(
              tags$style(
                paste0("#", paste0(uiid, "duration"), "{font-size: 25px; font-style: italic; font-weight: 700}")
              )
            )
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
          file = createFile()$path,
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
          file = createFile()$path,
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

  observeEvent(input$save_notes, {
    write_lines(input$notes, file = createFile()$notes_path)
  })

  # Renders the file path on the side panel
  output$madepath <- renderText({
    paste0("File created:<br>", createFile()$file)
  })

  observe({
    if (input$close > 0) {
      file.copy(createFile()$path, createFile()$path_final)
      stopApp() # stop shiny
    }
  })
}

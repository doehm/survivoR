# Confessional app server function
conf_app_server <- function(input, output) {

    # globals
    uiid <- paste0("x", str_pad(1:24, side = "left", width = 2, pad = 0))

    # reactives
    cfnl_id <- reactiveValues(k = 0)
    global_stamp <- reactiveValues(id = 0)
    action <- reactiveValues(id = 0)
    valid_selection_id <- reactiveValues(a = FALSE)
    prev <- reactiveValues(action = "stop")

    # create file when button clicked -----------------------------------------

    createFile <- eventReactive(input$create_file, {

      # check if it is a valid selection
      .season <- str_pad(input$season, side = "left", width = 2, pad = 0)
      .episode <- str_pad(input$episode, side = "left", width = 2, pad = 0)
      .vs <- paste0(input$version, .season)
      .time <- format(now(), "%Y-%m-%d %Hh%Mm%Ss")

      # check if valid selection
      valid_selections <- read_csv(
        "https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/valid-selections.csv",
        show_col_types = FALSE
      )

      selected <- valid_selections %>%
        filter(
          version_season == paste0(input$version, .season),
          episode == input$episode
        )

      # TODO: Don't want this to actually fail rather alert and allow for another selection
      # or just dynamically update the input fields
      if(nrow(selected) == 0) {

        shinyalert("The tribe has spoken", glue("Sorry, data doesn't exist for {paste0(input$version, .season)} episode {input$episode}"), type = "error")

        removeUI(selector = "#file_name_id")
        insertUI(
          selector = "#file_name",
          ui = tags$div(
            HTML("File not created..."),
            id = "file_name_id"
          )
        )

        list(valid = FALSE)

      } else {

        valid_selection_id$a <- TRUE

        # create directories
        dir <- file.path(input$path, .vs, input$episode)
        if(!dir.exists(dir)) dir.create(dir, recursive = TRUE)

        insertUI(
          selector = "#log_hdr",
          ui = h3("Timestamp log:", class="log", id = "log_hdr")
        )

        removeUI(selector = "#file_name_id")
        insertUI(
          selector = "#file_name",
          ui = tags$div(
            HTML(glue("File name:<br>{paste0(.time, ' ', input$version, .season, .episode, '.csv')}")),
            id = "file_name_id"
          )
        )

        # output list
        list(
          valid = TRUE,
          time = .time,
          vs = paste0(input$version, .season),
          path = input$path,
          file = paste0(.time, " ", .vs, .episode, ".csv"),
          path_notes = file.path(dir, paste0("[notes] ", .time, " ", .vs, .episode, ".txt")),
          path_edits = file.path(dir, paste0("[edits] ", .time, " ", .vs, .episode, ".csv")),
          path_staging = file.path(dir, paste0("[staging] ", .time, " ", .vs, .episode, ".csv")),
          path_final = file.path(dir, paste0("[final] ", .time, " ", .vs, .episode, ".csv"))
        )

      }

    })

    # Renders the file path on the side panel
    # don't need this anymore but keeping it because it makes the spinner work
    output$madepath <- eventReactive(input$create_file, {

      renderText({
        paste0("File created:<br>", createFile()$file)
      })

    })

    observe({

      if(createFile()$valid) {

      }

    })

    # create data frame when create file clicked ------------------------------

    # make the castaway data frame
    df <- reactive({

      if(valid_selection_id$a) {

        .vs <- createFile()$vs

        if(!.vs %in% survivoR::season_summary$version_season) {
          in_progress_vs <- readLines("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/vs.txt")
          online_file <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-boot-mapping.csv")
          online_file_tribe_colours <- glue("https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/{.vs}-tribe-colours.csv")
          df_boot_mapping <- read_csv(online_file, show_col_types = FALSE)
          df_tribe_colours <- read_csv(online_file_tribe_colours, show_col_types = FALSE) %>%
            distinct(version, version_season, season, tribe, tribe_colour)
        } else {
          df_boot_mapping <- survivoR::boot_mapping
          df_tribe_colours <- survivoR::tribe_colours
        }

        # make cast table
        df_cast <- df_boot_mapping %>%
          filter(
            version == input$version,
            season == input$season,
            episode == input$episode
          ) %>%
          group_by(version_season, castaway, castaway_id) %>%
          slice_min(order) %>%
          ungroup() %>%
          distinct(version_season, castaway, castaway_id, tribe, tribe_status) %>%
          left_join(
            df_boot_mapping %>%
              filter(
                version == input$version,
                season == input$season,
                episode == 1
              ) %>%
              group_by(version_season, castaway_id) %>%
              slice_min(order) %>%
              ungroup() %>%
              distinct(version_season, castaway_id, original_tribe = tribe),
            by = c("version_season", "castaway_id")
          ) %>%
          mutate(tribe = ifelse(tribe_status == "Merged", original_tribe, tribe)) %>%
          arrange(tribe, castaway) %>%
          mutate(
            uiid = paste0("x", str_pad(1:n(), side = "left", width = 2, pad = 0)),
            num = 1:n(),
            image = get_castaway_image(castaway_id, version_season)
          ) %>%
          left_join(
            df_tribe_colours %>%
              filter(
                version == input$version,
                season == input$season
              ) %>%
              distinct(version_season, tribe, tribe_colour),
            by = c("version_season", "tribe"))

        list(
          cast = df_cast,
          tribes = df_cast %>%
            distinct(tribe, tribe_colour)
        )

      }

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
          image = df()$cast$image[df()$cast$uiid == .x],
          tribe_colour = df()$cast$tribe_colour[df()$cast$uiid == .x]
        )
      }) %>%
        set_names(uiid)
    })

    # ts means time stamp
    ts <- map(uiid, ~reactiveValues(start = now(), stop = now(), duration = 0)) %>%
      set_names(uiid)

    # creates the UI components -----------------------------------------------

    # buttons based on the number of castaways
    observe({

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
              tags$img(
                src = lab_ls()[[uiid]]$image,
                height = 60,
                class = "cast-images",
                style = glue("border: 2.5px solid {lab_ls()[[uiid]]$tribe_colour};")
                ),
              actionButton(paste0(uiid, "Start"), "Start"),
              actionButton(paste0(uiid, "Stop"), "Stop"),
              tags$head(
                tags$style(
                  paste0("#", uiid, "duration", "{font-size: 32px; font-style: italic; font-weight: 700; }"),
                  paste0("#", uiid, "Start", "{border-color: ", cols[which(ids == uiid)], "; border-width: 2px; border-radius: 20px}"),
                  paste0("#", uiid, "Stop", "{border-color: ", cols[which(ids == uiid)], "; border-width: 2px; border-radius: 20px}"),
                )
              ),
              column(3, htmlOutput(paste0(uiid, "duration"))),
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
          cfnl_id$k <- cfnl_id$k + as.numeric(prev$action == "stop")
          global_stamp$id  <- global_stamp$id + 1
          prev$action <- "start"
          ts[[.uiid]]$start <- now()
          df_x <- data.frame(
            global_id = global_stamp$id,
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
                global_stamp$id,
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
          ts[[.uiid]]$duration <- ts[[.uiid]]$duration + (prev$action == "start")*round(as.numeric(difftime(ts[[.uiid]]$stop, ts[[.uiid]]$start, units = "secs")))
          global_stamp$id  <- global_stamp$id + 1
          df_x <- data.frame(
            global_id = global_stamp$id,
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

          prev$action <- "stop"
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
                global_stamp$id,
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

    # renders the duration to display on the dashy ----------------------------

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

    # save edits --------------------------------------------------------------

    observeEvent(input$apply_adj, {

      df_edits <- data.frame(
        global_id = input$id_adj,
        value = input$value_adj
      )

      write_csv(
        df_edits,
        file = createFile()$path_edits,
        append = TRUE
      )

      # add stamp when adjustment is applied
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
            "</strong><span class='stamp' style='color:blue;'>[adjustment] ID",
            input$id_adj,
            ": ",
            ifelse(is.na(input$value_adj), "", input$value_adj),
            "</span>",
            "<br>"
          ),
          id = action$id
        )
      )

    })

    # save notes to notes -----------------------------------------------------

    observeEvent(any(input$save_notes, input$close), {
      write_lines(input$notes, file = createFile()$path_notes)
    })

    # write final -------------------------------------------------------------

    observeEvent(any(input$show_time, input$close), {

      if(file.exists(createFile()$path_edits)) {

        staging <- read_csv(
          createFile()$path_staging,
          col_names = c("global_id", "id", "castaway", "action", "time"),
          show_col_types = FALSE
        )

        edits <- read_csv(
          createFile()$path_edits,
          col_names = c("global_id", "value"),
          show_col_types = FALSE,
        ) %>%
          distinct()

        staging %>%
          anti_join(
            edits %>%
              filter(value == "Delete"),
            by = "global_id"
          ) %>%
          left_join(
            edits %>%
              filter(value != "Delete") %>%
              mutate(value = as.numeric(value)) %>%
              group_by(global_id) %>%
              summarise(value = sum(value)),
            by = "global_id"
          ) %>%
          mutate(
            value = ifelse(is.na(value), 0, value),
            time = time + value
          ) %>%
          select(-value) %>%
          write_csv(createFile()$path_final)

      } else if(file.exists(createFile()$path_staging)) {

        read_csv(
          createFile()$path_staging, show_col_types = FALSE,
          col_names = c("global_id", "id", "castaway", "action", "time")
          ) %>%
          write_csv(createFile()$path_final)

      }

    })

    # show time ---------------------------------------------------------------

    df_conf_time <- eventReactive(input$show_time, {

      get_confessional_timing(
        paths = createFile()$path_final,
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

    # refresh -----------------------------------------------------------------

    observeEvent(input$refresh, {
      shinyjs::js$refresh_page()
    })

    # close app ---------------------------------------------------------------

    observeEvent(input$close, {
      if(valid_selection_id$a) {

        message(green(glue(
          "\n\nTo summarise the data run...\n\nget_confessional_timing('{createFile()$path_final}','{createFile()$vs}',{input$episode})\n")))

      }

      # clean environment
      rm(confApp, envir = .GlobalEnv)

      stopApp()

    })

  }


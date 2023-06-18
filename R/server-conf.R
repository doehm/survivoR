# Confessional app server function
conf_app_server <- function(input, output, session) {

    # globals    # the maximum number of castaways is 24
    uiid <- paste0("x", str_pad(1:24, side = "left", width = 2, pad = 0))

    # reactives
    cfnl <- reactiveValues(id = 0)
    global_stamp <- reactiveValues(id = 0)
    action <- reactiveValues(id = 0)
    valid_selection <- reactiveValues(id = FALSE)
    start <- reactiveValues(clicks = 0)
    timestamps <- reactiveValues(
      staging = NULL,
      edits = NULL,
      final = NULL
      )

    # ts means time stamp
    ts <- map(uiid, ~reactiveValues(
      start = now(),
      stop = now(),
      duration = 0,
      prev_action = "stop",
      duration_poll = NULL
      )
    ) %>%
    set_names(uiid)

    # user guide
    output$user_guide <- renderUI({
      user_guide_text(confApp$allow_write)
    })

    output$path_input <- renderUI({
      if(confApp$allow_write) {
        textInput("path", "Path", value = confApp$default_path)
      }
    })

    output$save_notes_button <- renderUI({
      if(confApp$allow_write) {
        actionButton("save_notes", HTML("&nbsp;Save notes"), icon = icon("save"))
      }
    })

    # create selector UI ------------------------------------------------------

    df_valid_selection <- read_csv(
      "https://raw.githubusercontent.com/doehm/survivoR/master/dev/data/in-progress/valid-selections.csv",
      show_col_types = FALSE
    ) %>%
      mutate(
        version = str_sub(version_season, 1, 2),
        season = as.numeric(str_sub(version_season, 3, 4))
      )

    output$season_selector <- renderUI({

      vse_selection <- df_valid_selection %>%
        filter(version == input$version)

      seasons <- sort(unique(vse_selection$season), decreasing = TRUE)

      column(4, selectInput("season", "Season", choices = seasons, selected = max(seasons)))

    })

    output$episode_selector <- renderUI({

      if(length(input$season == 1)) {
        vse_selection <- df_valid_selection %>%
          filter(
            version == input$version,
            season == as.numeric(input$season)
            )

        episodes <- sort(unique(vse_selection$episode), decreasing = TRUE)

        column(4, selectInput("episode", "Episode", selected = max(episodes), choices = episodes))
      }

    })

    # start button counter ----------------------------------------------------

    observeEvent(input$create_file, {

      start$clicks <- start$clicks + 1

      if(start$clicks > 1) {
        showModal(
          modalDialog(
            title = HTML("<div style='font-weight:700; font-size:24px'>Refresh selection?</div>"),
            tagList(
              HTML("<center>To refresh the selection you'll need to refresh the page</center>")
              ),
            footer = tagList(
              actionButton("ok_refresh", HTML("&nbsp;Refresh page"), icon = icon("rotate-right")),
              modalButton("Cancel")
            ),
            size = "s",
            easyClose = TRUE
          )
        )
      }
    })

    # create file when button clicked -----------------------------------------

    createFile <- eventReactive(input$create_file, {

      # check if it is a valid selection
      .season <- str_pad(input$season, side = "left", width = 2, pad = 0)
      .episode <- str_pad(input$episode, side = "left", width = 2, pad = 0)
      .vs <- paste0(input$version, .season)
      .time <- format(now(), "%Y-%m-%d %Hh%Mm%Ss")

      valid_selection$id <- TRUE

      # create directories
      if(confApp$allow_write) {

        dir <- file.path(input$path, .vs, input$episode)
        if(!dir.exists(dir)) dir.create(dir, recursive = TRUE)

        removeUI(selector = "#file_name_id")

        insertUI(
          selector = "#file_name",
          ui = tags$div(
            HTML(glue("File name:<br>{paste0(.time, ' ', .vs, .episode, '.csv')}")),
            id = "file_name_id"
          )
        )

      } else {

          dir <- confApp$default_path

      }

      if(start$clicks <= 1) {
        insertUI(
          selector = "#log_hdr",
          ui = h3("Timestamp log:", class="log", id = "log_hdr")
        )
      }

      # output list
      list(
        valid = TRUE,
        time = .time,
        vs = .vs,
        path = input$path,
        file = paste0(.time, " ", .vs, .episode, ".csv"),
        path_notes = file.path(dir, paste0("[notes] ", .time, " ", .vs, .episode, ".txt")),
        path_edits = file.path(dir, paste0("[edits] ", .time, " ", .vs, .episode, ".csv")),
        path_staging = file.path(dir, paste0("[staging] ", .time, " ", .vs, .episode, ".csv")),
        path_final = file.path(dir, paste0("[final] ", .time, " ", .vs, .episode, ".csv"))
      )

    })

    # create data frame when create file clicked ------------------------------

    # make the castaway data frame
    df <- eventReactive(input$create_file, {

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
          season == as.numeric(input$season),
          episode == as.numeric(input$episode)
        ) %>%
        group_by(version_season, castaway, castaway_id) %>%
        slice_min(order) %>%
        ungroup() %>%
        distinct(version_season, castaway, castaway_id, tribe, tribe_status) %>%
        left_join(
          df_boot_mapping %>%
            filter(
              version == input$version,
              season == as.numeric(input$season),
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
          placeholder_pos = num %% 2,
          image = get_castaway_image(castaway_id, version_season)
        ) %>%
        left_join(
          df_tribe_colours %>%
            filter(
              version == input$version,
              season == as.numeric(input$season)
            ) %>%
            distinct(version_season, tribe, tribe_colour),
          by = c("version_season", "tribe"))

      list(
        cast = df_cast,
        tribes = df_cast %>%
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
          image = df()$cast$image[df()$cast$uiid == .x],
          tribe_colour = df()$cast$tribe_colour[df()$cast$uiid == .x]
        )
      }) %>%
        set_names(uiid)
    })

    # creates the UI components -----------------------------------------------

    observe({

      if(start$clicks <= 1) {

        # tribe headers
        tribes <- df()$tribes$tribe
        tribe_cols <- df()$tribes$tribe_colour
        n_tribes <- length(tribes)

        if(n_tribes > 2) {
          pos <- 0
          scale <- 1
          tribes_2 <- tribes
        } else {
          tribes_2 <- sort(rep(tribes, 2))
          scale <- 2
          n_tribes <- 4
        }

        for(k in 1:n_tribes) {
          insertUI(
            selector = paste0("#tribe_name_", k),
            ui = tags$div(
              HTML(glue("<h2 class='hdr-bg' style='
                  background: {tribe_cols[which(tribes == tribes_2[k])]};
                  align='center'>{tribes_2[k]}</h2>")),
              id = "tribe_hdr"
            )
          )
        }

      }

    })

    lapply(
      uiid,
      function(.uiid) {
        observe({

          if(start$clicks <= 1) {

            ids <- df()$cast$uiid
            cols <- df()$cast$tribe_colour
            tribes <- df()$tribes$tribe
            tribe <- df()$cast$tribe
            tribe_cols <- df()$tribes$tribe_colour
            n_tribes <- length(tribes)

            if(n_tribes > 2) {
              pos <- 0
              scale <- 1
            } else {
              pos <- df()$cast$placeholder_pos[which(ids == .uiid)]
              scale <- 2
            }

            insertUI(
              selector = paste0("#placeholder", scale*(which(tribes == tribe[which(ids == .uiid)])-1) + 1 + pos),
              ui = tags$div(
                fluidRow(
                  br(),
                  strong(HTML(glue("<center><span style='font-size:22px'>{lab_ls()[[.uiid]]$name0}</span></center>"))),
                ),
                fluidRow(
                  column(4,
                    tags$img(
                      src = lab_ls()[[.uiid]]$image,
                      height = 60,
                      class = "cast-images",
                      style = glue("border: 2px solid {lab_ls()[[.uiid]]$tribe_colour};")
                    ),
                    tags$head(
                      tags$style(
                        paste0("#", .uiid, "duration", "{font-size: 32px; font-style: italic; font-weight: 700; }"),
                        paste0("#", .uiid, "Start", "{border-color: ", cols[which(ids == .uiid)], "; border-width: 2px; border-radius: 20px}")
                      )
                    )
                  ),
                  column(4, uiOutput(paste0(.uiid, "start_stop_button"))),
                  column(4, htmlOutput(paste0(.uiid, "duration"), class = "duration"))
                ),
                id = "booger"
              )
            )
          }
        })
      }
    )

    # make the start buttons
    lapply(
      uiid,
      function(.uiid) {
        output[[paste0(.uiid, "start_stop_button")]] <- renderUI({
          if(ts[[.uiid]]$prev_action == "start") {
            actionButton(
              paste0(.uiid, "Start"),
              HTML("&nbspStop"),
              style = "background-color:red; color:white",
              class = "start-button",
              icon = icon("stop")
              )
          } else {
            actionButton(
              paste0(.uiid, "Start"),
              HTML("&nbspStart"),
              class = "start-button",
              icon = icon("play")
              )
          }
        })
      })

    # observe button click and stamp time -------------------------------------

    # start
    lapply(
      uiid,
      function(.uiid) {
        observeEvent(input[[lab_ls()[[.uiid]]$action_start]], {

          all_prev_actions <- all(map_chr(ts, ~.x$prev_action) == "stop")

          if(all_prev_actions | ts[[.uiid]]$prev_action == "start") {

            if(ts[[.uiid]]$prev_action == "stop") {
              cfnl$id <- cfnl$id + 1
              global_stamp$id  <- global_stamp$id + 1
              ts[[.uiid]]$start <- now()
              ts[[.uiid]]$prev_action <- "start"
            } else if(ts[[.uiid]]$prev_action == "start") {
              ts[[.uiid]]$duration <- ts[[.uiid]]$duration + as.numeric(difftime(now(), ts[[.uiid]]$start, units = "secs"))
              ts[[.uiid]]$start <- now()
              global_stamp$id  <- global_stamp$id + 1
              ts[[.uiid]]$prev_action <- "stop"
            }

            # new row for data frame
            df_x <- data.frame(
              global_id = global_stamp$id,
              id = cfnl$id,
              castaway = df()$cast$castaway[df()$cast$uiid == .uiid],
              action = ts[[.uiid]]$prev_action,
              time = ts[[.uiid]]$start
            )

            # append to data frame
            timestamps$staging <- timestamps$staging %>%
              bind_rows(df_x)

            # write
            if(confApp$allow_write) {
              write_csv(
                df_x,
                file = createFile()$path_staging,
                append = TRUE
              )
            }

            action$id <- action$id + 1
            if(action$id > 30) {
              removeUI(
                selector = paste0("#", action$id-30)
              )
            }

            # insert time stamp in log
            col <- ifelse(ts[[.uiid]]$prev_action == "start", "red", "green")
            insertUI(
              selector = "#timestamps",
              ui = tags$span(
                HTML(
                  glue("<span class='stamp'>{cfnl$id} <strong class='stamp'>{df()$cast$castaway[df()$cast$uiid == .uiid]}</strong>"),
                  glue("<span class='stamp' style='color:{col};'>{ts[[.uiid]]$prev_action}:</span>"),
                  format(ts[[.uiid]]$start, "%H:%M:%S"),
                  "<br>"
                ),
                id = action$id,
                class = "stamp"
              )
            )
          }
        })
      }
    )

    # renders the duration to display on the dashy ----------------------------

    lapply(
      uiid,
      function(.uiid) {
        ts[[.uiid]]$duration_poll <- reactivePoll(
          1000,
          session,
          checkFunc = function() {
            if(ts[[.uiid]]$prev_action == "start") {
              now()
            } else {
              NULL
            }
          },
          valueFunc = function() {
            if(ts[[.uiid]]$prev_action == "start") {
              paste0("<span style='color:red;'>", round(ts[[.uiid]]$duration + as.numeric(difftime(now(), ts[[.uiid]]$start, units = "secs"))), "</span>")
            } else {
              round(ts[[.uiid]]$duration)
            }
          }
        )
      }
    )

    lapply(
      uiid,
      function(.uiid) {
        output[[paste0(.uiid, "duration")]] <- renderText({
          ts[[.uiid]]$duration_poll()
        })
      })

    # save edits --------------------------------------------------------------

    observeEvent(input$apply_adj, {

      df_edits <- data.frame(
        id = input$id_adj,
        value = input$value_adj
      )

      # append to df
      timestamps$edits <- timestamps$edits %>%
        bind_rows(df_edits)

      if(confApp$allow_write) {

        # write to file
        write_csv(
          df_edits,
          file = createFile()$path_edits,
          append = TRUE
        )

      }

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

      # apply edits first
      timestamps$final <- apply_edits(timestamps$staging, timestamps$edits)
      df_timing_tbl <- get_confessional_timing(
        timestamps$final,
        .vs = createFile()$vs,
        .episode = as.numeric(input$episode))

      # refresh duration
      lapply(
        uiid,
        function(.uiid) {
          .castaway <- df()$cast$castaway[which(df()$cast$uiid == .uiid)]
          ts[[.uiid]]$duration <- df_timing_tbl$confessional_time[which(df_timing_tbl$castaway == .castaway)]
        }
      )

    })

    # save notes -------------------------------------------------------------

    observeEvent(input$save_notes, {

      if(confApp$allow_write) {
        write_lines(input$notes, file = createFile()$path_notes)
      }

    })

    # write final -------------------------------------------------------------

    observeEvent(input$show_time, {

      # apply edits first
      if(!is.null(timestamps$staging)) {
        if(!is.null(timestamps$edits)) {
          timestamps$final <- apply_edits(timestamps$staging, timestamps$edits)
        } else {
          timestamps$final <- timestamps$staging
        }
        if(confApp$allow_write) {
          timestamps$final %>%
            write_csv(createFile()$path_final)
        }
      }

    })

    # show time ---------------------------------------------------------------

    df_conf_time <- eventReactive(input$show_time, {

      get_confessional_timing(
        timestamps$final,
        .vs = createFile()$vs,
        .episode = as.numeric(input$episode))

    })

    # popup to show the aggregated confessional times. ------------------------

    # TODO: would be good to have an open to download this directly to a csv/excel file
    observeEvent(input$show_time, {

      output$tbl_conf_timing <- renderDT({
        DT::datatable(
          df_conf_time(),
          rownames = FALSE,
          options = list(
            paging = FALSE,
            searching = FALSE
          )
        )
      })

      showModal(
        modalDialog(
          title = HTML("<div style='font-weight:700; font-size:24px'>Confessional timing</div>"),
          subtitle = "Copy and paste into Google Sheets",
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

    observeEvent(input$ok_refresh, {

      shinyjs::js$refresh_page()

    })

    # close app ---------------------------------------------------------------

    observeEvent(input$close, {

      if(valid_selection$id) {

        close_text <- ifelse(
          !confApp$allow_write,
          "Confessional times will be lost after closing app. Click 'show times' and copy
          the data before closing.<br><br>Do you want to close the session?",
          glue("The output files are saved at<br>{createFile()$path}<br><br>Do you want to close the session?")
          )

      } else {

        close_text <- "Do you want to close the session?"

      }

      showModal(modalDialog(
        tagList(
          HTML(glue("<center>{close_text}</center>"))
        ),
        title=HTML("<div style='font-weight:500; font-size:24px'>Close confessional app?</div>"),
        footer = tagList(
          actionButton("confirm_close", "Yes", onclick = "setTimeout(function(){window.close();},500);"),
          modalButton("Cancel")
        )
      ))

    })

    observeEvent(input$confirm_close, {

      if(valid_selection$id) {

        # apply edits first and save data sets
        if(!is.null(timestamps$staging)) {
          if(!is.null(timestamps$edits)) {
            timestamps$final <- apply_edits(timestamps$staging, timestamps$edits)
          } else {
            timestamps$final <- timestamps$staging
          }
          if(confApp$allow_write) {
            timestamps$final %>%
              write_csv(createFile()$path_final)
          }
        }

        if(confApp$allow_write) {
          write_lines(input$notes, file = createFile()$path_notes)
        }

        if(confApp$allow_write) {
          message(green(glue("\n\nTo summarise the data run...\n\nget_confessional_timing('{createFile()$path_final}','{createFile()$vs}',{input$episode})\n")))
        }

      }

      # clean environment
      rm(confApp, envir = .GlobalEnv)
      stopApp()

    })

  }


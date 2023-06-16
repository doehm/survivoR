# not exported helpers - globals for shiny app

# Apply adjustments
apply_edits <- function(.staging, .edits) {
  .staging %>%
    anti_join(
      .edits %>%
        filter(value == "Delete"),
      by = "id"
    ) %>%
    left_join(
      .edits %>%
        filter(value != "Delete") %>%
        mutate(value = as.numeric(value)) %>%
        group_by(id) %>%
        summarise(value = sum(value)),
      by = "id"
    ) %>%
    mutate(
      value = ifelse(is.na(value) | action == "start", 0, value),
      time = time + value
    ) %>%
    select(-value)
}

# user guide dynamic text
user_guide_text <- function(allow_write) {
  extra_notes <- c(
    ifelse(allow_write, "", ", and copy the table and paste into Excel or Google Sheets"),
    ifelse(allow_write, "", "<li>Please note that the timing will be lost once the app is closed.</li>"),
    ifelse(allow_write, "", ", however these will be lost once the app is closed. Installing
    <a target='_blank' href='https://github.com/doehm/survivoR'><code>survivoR</code></a>
    and running locally will allow you to save down the data")
  )
  HTML(glue("<ol>
     <li>Select the version, season and episode</li>
     <li><strong>Click 'Start'</strong>. The castaways will be populated
     in the main panel ordered by tribe</li>
     <li>While watching the episode <strong>click 'Start'</strong> when the castaway starts a confessionals. This includes
     if the confessional starts as a voice-over prior to them sitting.</li>
     <li><strong>Click 'Stop'</strong> when they stop talking.</li>
     <li>If the timer is started 2s late, stop the timer 2s after. Duration is what matters the most.</li>
     <li>If the the timer is started too late and need to make an adjustment:</li>
     <ol>
     <li>Input the ID number, and the value adjustment e.g. -5. If the
     time stamp needs to be deleted, input the ID and select 'Delete'.</li>
     <li>Click 'Apply adjustment'. Adjustments will be automatically applied
     and can be entered at any time.</li>
     </ol>
     <li><strong>When the episode finishes, click 'Show times'</strong>. A dialogue box will pop up
     where you can inspect the times and counts{extra_notes[1]}. You can check this throughout
     the session if desired.</li>
     {extra_notes[2]}
     <li><strong>Click 'Close app'</strong> to finish the session.</li>
     </ol>
     It's better to watch the epiosde in one sitting and either rewatch or make
     minor adjustments once the episode has episode has finished. For additional records you can
     record them in the <strong>'Notes'</strong> free text field{extra_notes[3]}."))
}

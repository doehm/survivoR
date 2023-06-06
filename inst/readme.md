This is under development is needed for it to be package worthy. However, this is a way for me to share it with others.

## To run the app

1.  Run `library(survivoR)`
2.  Run `launch_confessional_app()`
3.  Select the season and episode and hit 'create file'

And you're good to go

## How to use

1. Select the version, season and episode
2. Click 'Create file'. The castaways will be populated in the main panel ordered by tribe
3. While watching the episode 
    1. click 'Start' when the castaway starts a confessionals. This includes if the confessional starts as a voice-over prior to them sitting.
    2. Click 'Stop' when they stop talking.
    3. If the timer is started 2s late, stop the timer 2s after. Duration is what matters the most.
    4. If the the timer is started too late and need to make an adjustment:
        a. Input the ID number, and the value adjustment e.g. -5. If the time stamp needs to be deleted, input the ID and select 'Delete'.
        b. Click 'Apply adjustment'. Adjustments will be automatically applied and can be entered at any time.
5. When the episode finishes, click 'Show times'. A dialogue box will pop up where you can copy the table and paste into Excel of Google Sheets. You can check this throughout the session if desired.
6. Click 'Close app' to finish the session.

It's better to watch the epiosde in one sitting and either rewatch or make minor adjustments once the episode has episode has finished. For additional records you can record them in the 'Notes' free text field.

## When the episode ends

1.  Use `get_confessional_timing()` to summarise the data. It will return a data frame for the episode with the total length of confessional time as well as the confessional count as you would normally see it. It counts how many confessionals are more than 10 secs apart as per the normal rules.

## A few things to note

-   When selecting a season and episode for the first time the images may need to be downloaded first. It will look like it is hanging but it is just downloading. Shouldn't take any more than 10 secs.
-   Every time a start or stop button is pressed it writes a time stamp to a file. At first it will write a file to 'Staging', a sub-folder from the default path.
-   Notes is just a free text field where you can make notes about the episode or things to correct / check after the episode airs. For example maybe you accidentally hit start on the wrong person. Note down the id and delete it manually in the csv after the episode airs.
-   Notes when saved are in a sub-folder 'Notes'.

<center><img src='www/conf-timing.png'/></center>

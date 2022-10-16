This is experimental and more development is needed for it to be package worthy. However, this is a way for me to share it with others.

## To run the app

1.  run `library(survivoR)`
2.  run `source(file.path(system.file(package = "survivoR"), "confessionalDash/confapp.R"))`
3.  If it's the first time, set the default path for output `set_default_path(<your path>)`. Only have to do this once.
4.  run `launch_confessional_app()`
5.  Select the season and episode and hit 'create file'

And you're good to go

## How to use

1.  When a castaway begins talking in a confessional, hit start.
2.  When they stop, hit stop. That simple!

Keep in mind that this is designed to record the confessional lengths as the episode airs without pausing. The app records a time stamp of when the confessional begins and ends. Time doesn't stop, if you were to pause the episode mid confessional and picked it up later it would record a very long confessional.

## When the episode ends

After the app is closed, make any edits you may need to. When you are happy with the data

1.  Create another sub-folder 'Final'.
2.  Use `get_confessional_timing()` to summarise the data. It will return a data frame for the episode with the total length of confessional time as well as the confessional count as you would normally see it. It counts how many confessionals are more than 10 secs apart as per the normal rules.

## A few things to note

-   When selecting a season and episode for the first time the images may need to be downloaded first. It will look like it is hanging but it is just downloading. Shouldn't take any more than 10 secs.
-   Every time a start or stop button is pressed it writes a time stamp to a file. At first it will write a file to 'Staging', a sub-folder from the default path.
-   Notes is just a free text field where you can make notes about the episode or things to correct / check after the episode airs. For example maybe you accidentally hit start on the wrong person. Note down the id and delete it manually in the csv after the episode airs.
-   Notes when saved are in a sub-folder 'Notes'.

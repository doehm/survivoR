startup_message <- function()
{
  # Startup message obtained as
  msg <- "  Note: the 'challenges' dataset has been superseded by
  two new data sets 'challenge_results' and 'challenge_description'"
  return(msg)
}

.onAttach <- function(lib, pkg)
{
  msg <- startup_message()
  if(!interactive())
    msg[1] <- paste("Package 'survivoR' version", utils::packageVersion("survivoR"))
  packageStartupMessage(msg)
  invisible()
}

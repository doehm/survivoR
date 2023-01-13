.onAttach <- function(lib, pkg) {
  tryCatch(
    {
      git_version <- suppressWarnings(read.table("https://raw.githubusercontent.com/doehm/survivoR/master/inst/version-git.txt")[1,1])
      # git_version <- "2.0.6"
      git <- as.numeric(strsplit(git_version, "\\.")[[1]])
      sys_version <- as.character(utils::packageVersion("survivoR"))
      sys <- as.numeric(strsplit(sys_version, "\\.")[[1]])
      if(any(git - sys > 0)) {
        msg1 <- paste0("Package version on Git (", git_version, ") is ahead of system version (", sys_version, ")\n")
        msg2 <- "Install from Git for the latest data - devtools::install_github('doehm/survivoR')"
        packageStartupMessage(paste0(msg1, msg2))
      }
    },
    error = function(e) message("Head to https://github.com/doehm/survivoR to check for the latest data")
  )
}

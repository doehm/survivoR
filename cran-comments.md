## R CMD check results

0 errors | 0 warnings | 0 note

## Notes

* Version increment
* Adding complete US44, UK01 and NZ02 data
* New features
    * Shiny app. Launcher in helpers.R, UI in conf-ui.R and server in conf-server.R
    * This includes non-exported functions in helpers-ne.R
* The launch_confessional_app function includes an example to launch the shiny app and is wrapped in if(interactive()) {}. This is so it passes the CRAN test. I have followed other examples such as the 'runApp' documentation that does the same. If this is not correct please specify the precise way to write the example.

## Platforms tested

* Ubuntu Linux 20.04.1 LTS, R-release, GCC
* Fedora Linux, R-devel, clang, gfortran
* Windows Server 2022, R-devel, 64 bit

Passed with 2 notes

❯ checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

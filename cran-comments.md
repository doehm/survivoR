## R CMD check results

0 errors | 0 warnings | 0 note

## Notes

* Version increment
* Adding complete US44, UK01 and NZ02 data
* New features
    * Shiny app. Launcher in helpers.R, UI in conf-ui.R and server in conf-server.R
    * This includes non-exported functions in helpers-ne.R
* The launch_confessional_app function includes an example to launch the shiny app and is wrapped in if(interactive()) {} to pass CRAN checks. I have followed other examples such as the 'runApp' documentation that does the same. If this is not correct please specify the precise way to write the example.
* If the UI and server functions need to be included in a certain way, please specify.
* If the non-exported functions require included in a certain way, please specify.

## Platforms tested

* Ubuntu Linux 20.04.1 LTS, R-release, GCC
* Fedora Linux, R-devel, clang, gfortran
* Windows Server 2022, R-devel, 64 bit

Passed with 0 errors

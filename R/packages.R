# ----------------------------------------
# packages.R
# load or install packages
# kirstin.holsman@noaa.gov
# updated 2021
# ----------------------------------------
lib_list <- c(
  "devtools",
  # "svMisc",
  # "reshape",
  # "reshape2",
  "dplyr", 
  # "purrr",
  "readxl", 
  "visNetwork",
  "networkD3",
  "network" ,
  "tidyverse",
  "tidygraph",
  "ggraph",
  # "knitr",
  # "kableExtra",
  "RColorBrewer",
  "viridis",
  # "stringr",
  "ggplot2",
  "treemapify",
  # "mgcv",
  # "cowplot",               # 
  # "wesanderson",
  "plotly",
  "extrafont",
  "webshot",
  "gdtools",
  "hrbrthemes",
  "shinyjs",
  "magick"
  # nefsc shiny
  # "DiagrammeR","circlize",
  #"QPress",
  # "chorddiag", 
  # "kableExtra", "googledrive",
  # "DT"
)


# Install missing libraries:
missing <- setdiff(lib_list, installed.packages()[, 1])
if (length(missing) > 0) install.packages(missing)

# Load libraries:
for(lib in lib_list)
  suppressMessages(eval(parse(text=paste("library(",lib,")"))))

missing <- setdiff("chorddiag", installed.packages()[, 1])
if (length(missing) > 0) devtools::install_github("mattflor/chorddiag")
# missing <- setdiff("bsselectR", installed.packages()[, 1])
# if (length(missing) > 0) devtools::install_github("walkerke/bsselectR")
# # Load libraries:
# for(lib in c("chorddiag","bsselectR"))
for(lib in c("chorddiag"))
  suppressMessages(eval(parse(text=paste("library(",lib,")"))))

#install QPress
#install.packages(c("tcltk2", "XML", "devtools"))
#devtools::install_github("SWotherspoon/QPress", build_vignettes = TRUE)
#install chorddiag
#devtools::install_github("mattflor/chorddiag")
#install googlesheets4
#devtools::install_github("tidyverse/googlesheets4")
#install bsselectR
#devtools::install_github("walkerke/bsselectR")





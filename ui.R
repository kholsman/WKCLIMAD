#----------------------------------------
# WKCLIMAD 
# Kirstin Holsman 2022
#
#----------------------------------------
# remember you have to put the libraries here as library()! Can't load from the make.R
# also will load devtools installed libs
# library("shiny" )
library(devtools)
library(dplyr)
library(extrafont)
library(gdtools)
library(ggplot2)
library(ggraph)
library(hrbrthemes)
library(magick)
library(network)
library(networkD3)
library(plotly)
library(RColorBrewer)
library(readxl)
library(shinyjs)
library(tidygraph)
library(tidyverse)
library(treemapify)
library(viridis)
library(visNetwork)
library(webshot)
library(chorddiag)
# Install missing libraries:
# missing <- setdiff(lib_list, installed.packages()[, 1])
# if (length(missing) > 0) install.packages(missing)
# 
# # Load libraries:
# for(lib in lib_list)
#   suppressMessages(eval(parse(text=paste("library(",lib,")"))))
# 
# # missing <- setdiff("chorddiag", installed.packages()[, 1])
# # if (length(missing) > 0) devtools::install_github("mattflor/chorddiag")
# for(lib in c("chorddiag"))
#   suppressMessages(eval(parse(text=paste("library(",lib,")"))))


#source("R/packages.R")       # loads packages
source("R/setup.R")          # load other switches and controls
source("R/load_functions.R") # defines the create_plot() function
source("R/load_data.R")      # load other switches and controls

# suppressMessages(source("R/make.R"))

#source("R/sub_scripts/ntwk_analysis.R")

shinyUI(fluidPage(
  #includeCSS("www/timeline.css"),
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  # ),
  # tags$style(HTML("
  #       /*green*/
  #       .vis-foreground .vis-group:nth-of-type(1),
  #       .vis-foreground .vis-group:nth-of-type(2)
  #       {border-color: green; color: white; background-color: green;}
  #
  #        /*red*/
  #       .vis-foreground .vis-group:nth-of-type(3){ border-color: red; color: white; background-color: red; }
  #   ")),
  tags$head(
    tags$style(HTML(".red_style   { border-color: red; color: white; background-color: red; }
                     .green_style { line-color: black ;border-color: gray; color: black; background-color: white; }
                    "))
  ),
  titlePanel("WKCLIMAD Model Visualization"),
  tags$hr(),
  tags$hr(),
  helpText("Double click on the graph to reset to original extent "),
  verticalLayout(fluidRow(column(12,
                                 hr(),
                                 hr(),
                                 br(),
                                 helpText("Click and drag to zoom in (double click to zoom back out).")
  ))),
  tabsetPanel(
    id = "mainnav",
    tabPanel(
      div( "setup"),
      tags$hr(),
      actionButton("reset_input", "Reset inputs",color="gray"),
      uiOutput('resetable_input'),
    ),
    tabPanel(
      div(icon("cog"), "force"),
      forceNetworkOutput(outputId = "force"),
      downloadButton('d3', 'Download html graph'), 
      tags$hr(),
      numericInput("pngW3", label = "Width (px)",  value = 1800,  min = 1, max = 5000,  step = 1),
      numericInput("pngH3", label = "Height (px)",  value = 900,  min = 1, max = 5000,  step = 1),
      actionButton('downloadwebshot3', 'Download phantomjs (needed for webshot'),  
      actionButton('do3', 'Convert downloaded html to png')
    ),
    tabPanel(
      div(icon("cog"), "vis"),
      visNetworkOutput("vis") #,height = 250)
    )
    ,
    tabPanel(
      div(icon("cog"), "tree"),
      sliderInput("minSize", "Min freq",
                  min = 0, max = 100, value = 1),
      plotOutput("tree", click = "tClick"),
     
      fluidRow(
        verbatimTextOutput("out_text")
      ), DT::dataTableOutput("tdata")),
    tabPanel(
      div(icon("cog"), "Chord"),
      chorddiagOutput(outputId = "chord", height = 900),
      downloadButton('d2', 'Download html graph'), 
      tags$hr(),
      numericInput("pngW2", label = "Width (px)",  value = 1800,  min = 1, max = 5000,  step = 1),
      numericInput("pngH2", label = "Height (px)",  value = 900,  min = 1, max = 5000,  step = 1),
      actionButton('downloadwebshot2', 'Download phantomjs (needed for webshot'),  
      actionButton('do2', 'Convert downloaded html to png')
      # chorddiagOutput(outputId = "chord", height = 900)
      # simpleNetworkOutput("network")
    ),
   
    tabPanel(
      div(icon("cog"), "Sankey"),
      sankeyNetworkOutput("sankey"),
      downloadButton('d', 'Download html graph'), 
      tags$hr(),
      numericInput("pngW", label = "Width (px)",  value = 1800,  min = 1, max = 5000,  step = 1),
      numericInput("pngH", label = "Height (px)",  value = 900,  min = 1, max = 5000,  step = 1),
      actionButton('downloadwebshot', 'Download phantomjs (needed for webshot'),  
      actionButton('do', 'Convert downloaded html to png')
      # simpleNetworkOutput("sankey")
    )
  )
))


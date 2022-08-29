

# remember you have to put the libraries here! Can't load from the make.R
# library("shiny" )
# library("tidygraph")
# library("visNetwork")
# library("networkD3")
# library("ggraph")
# library("igraph")
# library("ggrepel")
# library("network")
# library("lubridate")
# library("tidyverse")
# library("reshape2")
# library("igraph")
# # load libraries
# library("plotly")  # interactive plots
# library("stringi") # used to wrap text strings in labels
# library("dplyr")    # used for manipulating datasets
# library("readxl")             # used for reading xls input files
# 
# 
# library("RColorBrewer")
# library("chorddiag")
# library("shinyWidgets")
# # library# install.packages("treemapify")
# library("treemapify")
# library("treemap")
# #library(d3treeR)
library("shiny" )
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

suppressMessages(source("R/make.R"))

if(1==10){
  input<-list()
  input$modlist <-models[1] 
  input$sinksRt  <- FALSE
  input$fontSize <- 16
  input$vis_layout <- "layout_with_sugiyama"
  input$align_hier <- "no"
  input$dist <- 100
  input$direction <-"LR"
}

# source("R/sub_scripts/ntwk_analysis.R")
# modlist  <- dir("data/shiny")
# modlist  <- modlist[grep("csv",modlist)]
shinyServer(function(input, output, session){
  # first create reactive data inputs for
  plotdat <- reactive({
    
    networks     <-  suppressWarnings(suppressMessages(
      plot_vis_network(
                                    modlistIN = input$modlist,
                                    fontSizeIN=input$fontSize,
                                    layoutIN =input$vis_layout,
                                    dirIN = input$direction,
                                    align_hierIN = input$align_hier,
                                    distIN =input$dist))) 
    network_vis   <- networks$vis
    network_force <- networks$force
    # network_force <- radialNetwork(Links = mod$edges_d3, Nodes = mod$nodes_d3, Source = "from", Target = "to", 
    #                               NodeID = "label", Group = "id", Value = "weight", 
    #                               opacity = 1, fontSize = input$fontSize, zoom = TRUE)
    # 
    #radialNetwork(List = mod$nodes_d3, fontSize = 10, opacity = 0.9)
    # sankey <- sankeyNetwork(Links = mod$edges_d3, Nodes = mod$nodes_d3, 
    #                              Source = "from", Target = "to",NodeGroup = "group" ,
    #                              NodeID = "label", Value = "weight", sinksRight=T,
    #                              fontSize = input$fontSize, unit = "Letter(s)")
    sankey <- suppressMessages(plot_Sankey(modlistIN = input$modlist, sinksRightIN= input$sinksRt,fontSizeIN=input$fontSize))
    mod    <- networks$mod
    chord  <- (suppressMessages(plot_chordDiag(input$modlist)))
    return(list(mod              = mod,
                network_vis      = network_vis,
                network_force    = network_force,
                sankey          = sankey,
                chord            = chord))
    
  })
  
# output$sankey <- renderSankeyNetwork({
#   plotdat()$sankey
# })
output$resetable_input <- renderUI({
  times <- input$reset_input
  div(id=letters[(times %% length(letters)) + 1],
      
      selectInput("modlist", label = "Model", choices = models,selectize = TRUE,selected = models,multiple = TRUE),
      selectInput("vis_layout", label = "Vis layout", 
                  choices = c("layout_nicely","layout_with_fr","layout_in_circle",
                              "layout_with_sugiyama"),
                  selectize = TRUE,selected = "layout_with_sugiyama",multiple = FALSE),
      
      radioButtons("align_hier", label = "align hierarchically?", 
                   choices = c("yes","no"),
                   selected =c("no")),
      radioButtons("sinksRt", label = "snakey right?", 
                   choices = c(TRUE,FALSE),
                   selected =c(FALSE)),
      radioButtons("direction", label = "direction hierarchically", 
                   choices = c("UD", "DU", "LR", "RL"),
                   selected =c("LR")),
      sliderInput("nodeSpacing", "Distance between nodes",
                  min = 1, max = 500, value = 200),
      sliderInput("dist", "Distance between levels",
                  min = 1, max = 500, value = 200),
      #checkboxGroupInput("above", label = "Which types above the line?", choices = levels(data_xls$type),selected =c("Milestone","Meeting")),
      numericInput("fontSize", label = "font size",  value = 16,  min = 1, max = 60,  step = 1))
  # numericInput("vert_mult", label = "Vertical spread for text",  value = 1,  min = 1, max = 3,  step = .01),
  # numericInput("mIN", label = "frequency of displayed months",  value = 3,  min = 1, max = 12,  step = 1),
  # numericInput("day_buffer", label = "buffer for timeline",  value = 90,  min = 0, max = 600,  step = 10))
})
# observeEvent(input$save_myPlot, {
#   shinyjs::runjs(
#     "
#        var p_src = document.getElementById('myPlot').childNodes[0].src; 
#        Shiny.setInputValue('plot_src', p_src);
#        document.getElementById('save_myPlot_hidden').click();
#       "
#   )
# })
# # downaload handler - save the image
# output$save_myPlot_hidden <- downloadHandler(
#   filename = function() { 
#     paste0("plot_", Sys.Date(), ".png") },
#   content = function(file) {
#     # get image code from URI
#     plot_src <- gsub("^data.*base64,", "", input$plot_src)
#     # decode the image code into the image
#     plot_image <- image_read(base64_decode(plot_src))
#     # save the image
#     image_write(plot_image, file)
#   })

# plot
# output$myPlot <- renderSankeyNetwork({
#   plotdat()$sankey
# })
output$sankey <- renderSankeyNetwork({
  plotdat()$sankey
})
output$chord <- renderChorddiag({
 plotdat()$chord
})
output$force <- renderForceNetwork({
  plotdat()$network_force
  })
# output$rad <-    renderRadialNetwork({
#   plotdat()$network_radial
# })
# output$rad <-    renderRadialNetwork({
#   plotdat()$network_radial
# })
# forceNetwork(Links = edges_d3, Nodes = nodes_d3,
# Source = "from", Source = "from", 
# Value = "weight", NodeID = "label", 
# Group = "id", opacity = 1, fontSize = 16, zoom = TRUE)

output$vis <- renderVisNetwork({
  plotdat()$network_vis
})
output$d <- downloadHandler(
  filename = function() {
    'SankeyPlot.html'
  },
  content = function(file) {
    saveNetwork( plotdat()$sankey, file)
  }
)
output$d2 <- downloadHandler(
  filename = function() {
    'ChordPlot.html'
  },
  content = function(file) {
    saveNetwork( plotdat()$chord, file)
  }
)
output$d3 <- downloadHandler(
  filename = function() {
    'ForcePlot.html'
  },
  content = function(file) {
    saveNetwork( plotdat()$network_force, file)
  }
)
PLOTFUNCTION<- function(){
  
  renderChorddiag({
    plotdat()$chord
  })
  
}
# output$d2 <- downloadHandler(
#   filename = function() {
#     'ChordPlot.png'
#   },
#   content = function(file) {
#    # if (input$d2 != 0) {
#       png(file)
#       PLOTFUNCTION()
#       dev.off()
#     # }else{
#     #   return()
#     # }
# })


# output$d2 <- downloadHandler(
#   filename = function() {
#     #paste("SankeyPlot_", Sys.Date(), ".png", sep="")
#     'SankeyPlot.png'
#   },
#   content = function(file) {
#     webshot::install_phantomjs()
#     webshot(file.path(path.expand("~/"),'../Downloads/SankeyPlot.html'),
#             file.path(path.expand("~/"),"../Downloads/",file), vwidth = 1400, vheight = 900)
#     
#  }
# )
observeEvent(input$do, {
 webshot(file.path(path.expand("~/"),'../Downloads/SankeyPlot.html'),
          file.path(path.expand("~/"),"../Downloads/SankeyPlot.png"), vwidth = input$pngW, vheight = input$pngH)
})
observeEvent(input$downloadwebshot, {
  webshot::install_phantomjs(force = T)
})
observeEvent(input$do2, {
  webshot(file.path(path.expand("~/"),'../Downloads/ChordPlot.html'),
          file.path(path.expand("~/"),"../Downloads/ChordPlot.png"), vwidth = input$pngW2, vheight = input$pngH2)
})
observeEvent(input$downloadwebshot2, {
  webshot::install_phantomjs(force = T)
})
observeEvent(input$do3, {
  webshot(file.path(path.expand("~/"),'../Downloads/ForcePlot.html'),
          file.path(path.expand("~/"),"../Downloads/ForcePlot.png"), vwidth = input$pngW3, vheight = input$pngH3)
})
observeEvent(input$downloadwebshot3, {
  webshot::install_phantomjs(force = T)
})
  
})


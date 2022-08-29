#'
#'setup.R
#'
#'Base script for setting up the repo
#'Kirstin.holsman@noaa.gov
#'
#'
 
  # Set switches for this code
  #----------------------------------------
  update.data         <- TRUE
  update.network.data <- FALSE
  
  # Set up file paths
  #----------------------------------------
  data.in            <-  file.path("Data/in")
  data.out           <-  file.path("Data/out")
  data.models        <-  file.path(data.out,"networkmodels")
  outfile.fig        <-  file.path("Figs/")
  
  if(!dir.exists(data.out))    dir.create(data.out)
  if(!dir.exists(data.in))     dir.create(data.in)
  if(!dir.exists(data.models)) dir.create(data.models)
  if(!dir.exists(outfile.fig)) dir.create(outfile.fig)
  
  # globals:
  #-------------------------------------------  
  models <- c("Fish_1_1",
              "Fish_1_2",
              "Fish_1_3",
              "Fish_2_1",
              "Fish_2_2",
              "Fish_2_3",
              "Aqua_1_1",
              "Aqua_1_2",
              "Aqua_1_3")
  
  
  # plotting stuff:
  #-------------------------------------------
  shp_str <- c(15,1,8,6,2,3,4, 17,7, 19,  5,  0)#sample(c(0:8, 15,19,17),12)
  grid_lwdIN     <- .4
  breaks         <- seq(0,250,50)
  pal            <- c(rev(RColorBrewer::brewer.pal(length(breaks)-1,"GnBu")),"white")
  # set up colors
  dawn        <-  colorRampPalette(c(colors()[c(477,491,72,474,47,653)],"orange","red"))
  colIN2 			<-  (brewer.pal(9, "RdBu"))
  colIN 			<-  (brewer.pal(9, "YlGnBu"))
  rescol 			<-  (brewer.pal(5, "YlOrRd"))[3]
  colIN 			<-  colorRampPalette(brewer.pal(9, "YlOrRd")[1:9])
  
  # Colour palettes
  water.col   <- colorRampPalette(c("purple4", "navy", "blue", "skyblue", "lightblue", "white"))
  grey.col    <- colorRampPalette(c("darkgray", "black"))
  
  # base colors:
  labelcol1   <- colorRampPalette(RColorBrewer::brewer.pal(11, "BrBG")[7:10])
  labelcol2   <- colorRampPalette(RColorBrewer::brewer.pal(9, "Spectral"))
  labelcol3   <- colorRampPalette(RColorBrewer::brewer.pal(8, "Accent"))
  labelcol3   <- colorRampPalette(RColorBrewer::brewer.pal(8, "Accent"))
  labelcol4   <- colorRampPalette(c(
    RColorBrewer::brewer.pal(6, "YlOrRd"),
    RColorBrewer::brewer.pal(8, "Blues"),
    RColorBrewer::brewer.pal(8, "BrBG")
  ))
  labelcol5   <- colorRampPalette(rev(c(
    RColorBrewer::brewer.pal(6, "YlOrRd"),
    RColorBrewer::brewer.pal(9, "BrBG")
  )))
  labelcol   <- colorRampPalette( RColorBrewer::brewer.pal(9, "Spectral")[c(9:6,3:1)])
  labelcol6v2   <- colorRampPalette(c(RColorBrewer::brewer.pal(11, "PRGn")[9],
                                      RColorBrewer::brewer.pal(11, "BrBG")[8:11]))
  labelcol6   <- colorRampPalette(rev(c(RColorBrewer::brewer.pal(11, "PRGn")[9:8],
                                        RColorBrewer::brewer.pal(11, "BrBG")[8:9])))
  Fig14_1_color_ramp <- colorRampPalette(c(labelcol6(9)[3:6]))
  Fig6_1_color_ramp  <- colorRampPalette(c(labelcol6(9)[2:9]))
  
  precip_col         <- colorRampPalette(RColorBrewer::brewer.pal(11, "BrBG"))
  
  sea_ice_col        <- colorRampPalette(c(RColorBrewer::brewer.pal(11, "BrBG")[11:7],"white"))
  sea_ice_col        <- colorRampPalette(sea_ice_col(20)[c(1,1,1,1,1,1:19)])
  
  SST_col            <- colorRampPalette(c("white",RColorBrewer::brewer.pal(9, "YlOrRd")[2:9]))
  tx40_col           <- colorRampPalette(c("white",RColorBrewer::brewer.pal(9, "YlOrRd")))
  mnT_col            <- colorRampPalette(rev(c(rev(RColorBrewer::brewer.pal(9, "YlOrRd")),
                                               "white",
                                               RColorBrewer::brewer.pal(9, "GnBu"))))
  inv_mnT_col        <- colorRampPalette((c(rev(RColorBrewer::brewer.pal(9, "YlOrRd")),
                                            "white",
                                            RColorBrewer::brewer.pal(9, "GnBu"))))
  
  percept_col <- colorRampPalette(rev(c(RColorBrewer::brewer.pal(11, "Spectral")[1:4],
                                        RColorBrewer::brewer.pal(11, "BrBG")[5:11])))
  percept_col <- colorRampPalette((c(rev(RColorBrewer::brewer.pal(9, "YlOrRd")),
                                     "white",
                                     RColorBrewer::brewer.pal(9, "GnBu"))))
  percept_col <- colorRampPalette((c(rev(RColorBrewer::brewer.pal(9, "YlOrRd")),
                                     "white",
                                     RColorBrewer::brewer.pal(9, "PuBuGn"))))
  
save.image(file.path(data.out,"setup.Rdata"))


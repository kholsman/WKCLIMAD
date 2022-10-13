#'
#'
#'plot_chordDiag2.R
#'
if(1==10){
  suppressMessages(source("R/packages.R"))      # loads packages
  suppressMessages(source("R/make.R"))
  
  
  input            <- list()
  input$modlist    <- models[1] 
  input$sinksRt    <- FALSE
  input$fontSize   <- 16
  input$vis_layout <- "layout_with_sugiyama"
  input$align_hier <- "no"
  input$dist       <- 100
  input$direction  <- "LR"
  input$minSize    <- 1
  
  x           = models[1:6]
  labW        = 30
  tblIN       = tbl
  tbl_metaIN  = tbl_meta
  links_allIN = links_all
}

plot_chordDiag2 <- function(x           = modlistIN,
                           labW        = 30,
                           tblIN       = tbl,
                           tbl_metaIN  = tbl_meta,
                           links_allIN = links_all){
  
  
  mm <- get_all_network(modlistIN)
  linksIN <- mm$links
  nodesIN <- mm$nodes_2
  nodesIN$plotLab <- str_wrap(nodesIN$plotID, width = labW)
  # 
  # linksIN <- links_all%>%filter(model%in%modlistIN)
  # nodesIN <- nodes_all%>%filter(model%in%modlistIN)
  # 
  
  nodesIN$plotLab <- str_wrap(nodesIN$plotID, width = labW)
  
  # create a df from the meta data
  cc <- tblIN%>%distinct(plotID,Category,Type)
  df <- tblIN%>%group_by(plotID,Category)%>%summarise(freq=length(plotID))%>%
    arrange(desc(freq))
  
  # create collated matrix of all networks
  # combine with tblIN_meta and reduce to plotID
  # collate to plot source()
  
  # create order for plotting
  cat <- data.frame(ID = unique(c(links_allIN$source,links_allIN$destination)))%>%
    left_join(tblIN, by=c("ID"="ID"))
  
  by_category <- cat%>%group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    arrange(Category, plotID)%>%
    mutate(plotID = factor(plotID,plotID))%>%rename(lab = Category)
  
  # Create matrix
  m   <- links_allIN%>%
    filter(value!=0.1, model%in%x)%>%
    select(source,destination,value,weight_source,weight_dest)%>%
    left_join(tbl_metaIN, by=c("source"="ID_long"))%>%rename(plot_source = Plot_text, Category_source=Category)%>%
    left_join(tbl_metaIN, by=c("destination"="ID_long"))%>%rename(plot_dest = Plot_text, Category_dest=Category)%>%
    filter(!is.na(plot_dest))%>%left_join(by_category,by=c("plot_source"="plotID"))
  m <- m%>%
    arrange(lab, plot_source)%>%select(plot_source,plot_dest, value)%>% 
    rename(source = plot_source, destination=plot_dest)%>%
    group_by(source,destination)%>%summarize(mean =mean(value,na.rm=T))%>%
    mutate(ordr= as.numeric(  factor(source,levels=by_category$plotID)))%>%
    arrange(ordr)%>%
    select(source,destination,mean)%>%filter(!is.na(source))
  
  # by_type <- links_allIN%>%
  #   group_by(plotID,Type)%>%
  #   summarize(freq=length(plotID))%>%
  #   arrange(Type, plotID)%>%
  #   mutate(plotID = factor(plotID,plotID))%>%rename(lab = Type)
  
  # 
  # # 
  # m2   <- links_allIN%>%
  #   arrange(Category, source)%>%
  #   group_by(source,destination)%>%summarize(mean =mean(value,na.rm=T))%>%
  #   select(source,destination,mean)
  
  
  wide   <- m%>%
    pivot_wider(names_from = destination, values_from = mean, values_fill =NA)%>%
    pivot_longer(!source,names_to = "destination",values_to="mean")
  matt <- expand.grid(unique(c(wide$source,wide$destination)),
                      unique(c(wide$source,wide$destination)))
  colnames(matt) <- c("source","destination")
  full_mat<-matt%>%left_join(wide)%>%
    pivot_wider(names_from = destination,values_from = mean, values_fill =NA)
  
  cc          <- viridis_pal(alpha = 1, begin = 0, end = .8, direction = 1, option = "D")
  ordr        <- by_category
  ordr$n      <- 1:dim(ordr)[1]
  
  meta_dat              <- data.frame(plotID=data.frame(full_mat)[,1])%>%left_join(ordr)
  meta_dat$rank         <- rank(meta_dat$n)
  meta_dat$labn         <- as.numeric(as.factor(meta_dat$lab))
  meta_dat$groupColors  <- cc(length(unique(meta_dat$lab)))[meta_dat$labn]
  meta_dat$labn2        <- as.numeric(as.factor(meta_dat$plotID))
  
  meta_dat$thickness    <- meta_dat$freq/sum( meta_dat$freq)
  
 # m             <- data.matrix(full_mat[order(meta_dat$rank),c(1,order(meta_dat$rank)+1)][,-1])
  m             <- data.matrix(full_mat[,-1])*meta_dat$freq
  #m             <- m[order(meta_dat$rank),order(meta_dat$rank)]
  rownames(m)   <- colnames(m)
  meta_dat      <- meta_dat%>%arrange(rank)
  meta_dat$groupColors2 <- cc(max(meta_dat$rank))[meta_dat$rank]
  
  meta_dat$gaps <- 1
  meta_dat$gaps[cumsum(as.numeric(tapply(meta_dat$plotID, meta_dat$lab, length)))] <- 7
  m <- m[match(meta_dat$plotID,rownames(m)),match(meta_dat$plotID,colnames(m))]
  
  require(circlize)
  
  # chordDiagram(m)
  # re-set circos parameters
  circos.clear()
  # par(mfrow = c(2, 1))
  
  circos.par(canvas.ylim  = c(-1.7,1.7), # edit  canvas size 
             gap.after    = meta_dat$gaps, # adjust gaps between regions
             track.margin = c(0.01, 0.03), # adjust bottom and top margin
             # track.margin = c(0.01, 0.1)
             track.height = 0.03)
  
  chordDiagram(m,
               grid.col    = meta_dat$groupColors2[meta_dat$rank],
               directional = 1, 
               diffHeight  = mm_h(3),
               order       = meta_dat$plotID,
               link.target.prop   = FALSE,
               target.prop.height = mm_h(1),
               direction.type     = c("diffHeight", "arrows"),
               link.arr.type      = "big.arrow",
               
               # plot only grid (no labels, no axis)
               preAllocateTracks = 2,
               annotationTrack   = c( "grid"), 
               
               # adjust grid width and spacing
               annotationTrackHeight = c(mm_h(2),mm_h(3)),
               transparency          = 0.1,
               link.lwd = 1,    # Line width
               link.lty = 1,    # Line type
               link.border           = cc(10)[1]) # Border color

  
  
  circos.track(track.index = 2, panel.fun = function(x, y) {
    xlim  = get.cell.meta.data("xlim")
    xplot = get.cell.meta.data("xplot")
    ylim  = get.cell.meta.data("ylim")
    sector.name = get.cell.meta.data("sector.index")
    meta.sub    = meta_dat[match(sector.name,meta_dat$plotID),]
    sector.col  =  meta.sub$groupColors2
   # strwidth(sector.name)
    
    if(abs(xplot[2] - xplot[1]) < 15) {
      circos.text(mean(xlim), ylim[1], str_wrap(sector.name, width = 100), 
                  facing = "clockwise",cex=0.5, #.1*abs(xplot[2] - xplot[1]),
                  niceFacing = TRUE, adj = c(0, 0.5), col = sector.col)
      
    } else {#bending.inside
      circos.text(mean(xlim), ylim[1],str_wrap(sector.name, width = labW), 
                  facing = "clockwise", cex=.8,font=2,
                  niceFacing = TRUE, adj = c(0, 0.5), col= sector.col)
    }
    # circos.text(mean(xlim), mean(ylim) + 4,str_wrap(meta.sub$lab, width = labW), 
    #             facing = "bending.inside", cex=.6,
    #             niceFacing = TRUE, adj = c(0, 0.5), col= sector.col)
    # # print axis
    # circos.axis(h = "bottom", labels.cex = 0.5, 
    #             # major.tick.percentage = 0.05, 
    #             major.tick.length = 0.6,
    #             sector.index = sector.name, track.index = 2)
  }, bg.border = NA)
  
  ii <- 0
  if(1==10){
    # add outer ring of categories
    for(l in unique(meta_dat$lab)){
      
      subset  <- meta_dat%>%filter(lab==l)
      rrr     <- which (rownames(m)%in%subset$plotID)
      ccc     <- which (colnames(m)%in%subset$plotID)
      ii <- ii +1
      highlight.sector(rownames(m)[rrr], track.index = 2, 
                       col = cc(length(unique(meta_dat$lab)))[ii],  facing = "clockwise",
                       text = NA, cex = 0.3,  #str_wrap(l, width = 20)
                       text.col = cc(10)[1], niceFacing = TRUE)
      
      
    }
  }
 
  
}


 

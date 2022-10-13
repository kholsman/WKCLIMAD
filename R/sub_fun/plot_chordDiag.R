#'
#'
#'plot_chordDiag.R
#'


plot_chordDiag <- function(x           = modlistIN,
                           labW        = 20,
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
  
  cc          <- viridis_pal(alpha = 1, begin = 0, end = 1, direction = 1, option = "D")
  ordr        <- by_category
  ordr$n     <- 1:dim(ordr)[1]
  meta_dat    <- data.frame(plotID=data.frame(full_mat)[,1])%>%left_join(ordr)
  meta_dat$rank <- rank(meta_dat$n)
  full_mat[meta_dat$rank,meta_dat$rank]
  meta_dat$labn         <- as.numeric(as.factor(meta_dat$lab))
  meta_dat$groupColors  <- cc(length(unique(meta_dat$lab)))[meta_dat$labn]
  meta_dat$labn2        <- as.numeric(as.factor(meta_dat$plotID))
  meta_dat$groupColors2 <- cc(length(unique(meta_dat$plotID)))[meta_dat$labn2]
  meta_dat$thickness    <-  meta_dat$freq/sum( meta_dat$freq)
  #meta_dat              <- meta_dat[meta_dat$rank,]
  
  #meta_dat$lab <- str_wrap(meta_dat$lab, width = 5)
  m           <- data.matrix(full_mat[meta_dat$rank,c(1,meta_dat$rank+1)][,-1])
  m           <- data.matrix(full_mat[,-1])*meta_dat$freq
  

   chorddiag(m,  
                 type = "directional",
                 width = 900,
                 height = 900,
                 margin = 120,
                 #groupThickness = meta_dat$thickness,
                 groupColors    = meta_dat$groupColors,
                 groupedgeColor = meta_dat$groupColors,
                 chordedgeColor = meta_dat$groupColors,
                 groupNames = meta_dat$lab,
                 groupnameFontsize = 9,
                 showGroupnames    = T,
                 # categoryNames = groupNames,
                 # categorynameFontsize=9,
                 # categorynamePadding=20,
                 groupnamePadding = 20, clickGroupAction =T)


}


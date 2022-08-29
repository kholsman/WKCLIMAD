#'
#'
#'plot_chordDiag.R
#'


plot_chordDiag <- function(x){

    
  # create a df from the meta data
    cc <- tbl%>%distinct(plotID,Category,Type)
    df <- tbl%>%group_by(plotID,Category)%>%summarise(freq=length(plotID))%>%
    arrange(desc(freq))
  
  # create collated matrix of all networks
  # combine with tbl_meta and reduce to plotID
  # collate to plot source()
 
  # create order for plotting
  cat <- data.frame(ID = unique(c(links_all$source,links_all$destination)))%>%
    left_join(tbl, by=c("ID"="ID"))
  
  by_category <- cat%>%group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    arrange(Category, plotID)%>%
    mutate(plotID = factor(plotID,plotID))%>%rename(lab = Category)
  
  # Create matrix
  m   <- links_all%>%
    filter(value!=0.1, model%in%x)%>%
    select(source,destination,value,weight_source,weight_dest)%>%
    left_join(tbl_meta, by=c("source"="ID_long"))%>%rename(plot_source = Plot_text, Category_source=Category)%>%
    left_join(tbl_meta, by=c("destination"="ID_long"))%>%rename(plot_dest = Plot_text, Category_dest=Category)%>%
    filter(!is.na(plot_dest))%>%left_join(by_category,by=c("plot_source"="plotID"))
  m <- m%>%
    arrange(lab, plot_source)%>%select(plot_source,plot_dest, value)%>% 
    rename(source = plot_source, destination=plot_dest)%>%
    group_by(source,destination)%>%summarize(mean =mean(value,na.rm=T))%>%
    mutate(ordr= as.numeric(  factor(source,levels=by_category$plotID)))%>%
    arrange(ordr)%>%
    select(source,destination,mean)%>%filter(!is.na(source))
  
  # by_type <- links_all%>%
  #   group_by(plotID,Type)%>%
  #   summarize(freq=length(plotID))%>%
  #   arrange(Type, plotID)%>%
  #   mutate(plotID = factor(plotID,plotID))%>%rename(lab = Type)
  
  # 
  # # 
  # m2   <- links_all%>%
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
  meta_dat    <- data.frame(plotID=data.frame(full_mat)[,1])%>%left_join(ordr)
  m           <- data.matrix(full_mat[,-1])
  groupColors <- cc(length(unique(meta_dat$lab)))[as.numeric(as.factor(meta_dat$lab))]
  groupNames  <- unique(meta_dat$lab)[as.numeric(as.factor(meta_dat$lab))]
  
  # Build the chord diagram:
  
  #Pick up here for - need to connect metadata and the matrix values....
  chorddiag(m,  
                 type = "directional",
                 width = 900,
                 height = 900,
                 margin = 120,
                 groupColors = groupColors,
                 groupedgeColor = groupColors,
                 chordedgeColor = groupColors,
                 groupnameFontsize = 9,
                 showGroupnames=T,
                 # categoryNames = groupNames,
                 # categorynameFontsize=9,
                 # categorynamePadding=20,
                 groupnamePadding = 20, clickGroupAction =T)

}


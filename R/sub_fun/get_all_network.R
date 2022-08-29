#'
#'
#'
#'get_all_network.R
#'

get_all_network<-function(modlist){
  
  
  links   <- links_all%>%filter(model%in%modlist)
  nodes   <- nodes_all%>%filter(model%in%modlist)
  edges   <- edges_all%>%filter(model%in%modlist)
  
  # create order for plotting
  cat <- data.frame(ID = unique(c(links_all$source,links_all$destination)))%>%
    left_join(tbl, by=c("ID"="ID"))
  
  by_category <- cat%>%group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    arrange(Category, plotID)%>%
    mutate(plotID = factor(plotID,plotID))%>%rename(lab = Category)
  
  # Create matrix
  m   <- links_all%>%
    #filter(value!=0.1, model%in%modlist)%>%
    filter(model%in%modlist)%>%
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
    select(source,destination,mean)%>%filter(!is.na(source))%>%rename(value=mean)%>%ungroup()
  
  
  nodesa <- data.frame(
    label=c(as.character(m$source), 
            as.character(m$destination)) %>% 
      unique())%>%rowid_to_column("id")
  
  # With networkD3, connection must be provided using id, not using real 
  # name like in the links dataframe.. So we need to reformat it.
  
  m$IDsource      <- match(m$source, nodesa$label)-1 
  m$IDdestination <- match(m$destination, nodesa$label)-1
  
  #edges <- data.frame(from = m$IDsource+1, to =m$IDsource)
  
  # create order for plotting
  tmp <- data.frame(plotID = unique(c(m$source,m$destination)))%>%
    left_join(tbl, by=c("plotID"="plotID"))%>%
    group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    arrange(Category, plotID)%>%
    mutate(plotID = factor(plotID,plotID))%>%mutate(lab = Category)%>%ungroup()
  if(1==10){
    tmp <- data.frame(plotID = unique(c(m$source,m$destination)))%>%
      left_join(tbl, by=c("plotID"="plotID"))%>%
      group_by(plotID,Category)%>%
      summarize(freq=length(plotID))%>%
      arrange(Category, plotID)
    tmp[which(tmp$plotID==tmp$plotID[duplicated(tmp$plotID)]),]
  }
  nodes1 <- data.frame(plotID = unique(c(m$source,m$destination)))%>%
    left_join(tbl, by=c("plotID"="plotID"))%>%
    group_by(plotID,Category,Type)%>%
    mutate(Type  = factor(Type,c( "Sub-components",
                                  "Supportive Elements",
                                  "Climate-informed Management Tool",
                                  "Adaptation Measures Addressed")),
           typeN  = as.numeric(Type))%>%
    summarize(freq=length(plotID),level = round(mean(typeN)),0)%>%
    arrange(Category, plotID)%>%
   mutate( plotID2 = paste0(level,plotID),
           plotID= factor(plotID,tmp$plotID),
           lab    = Category,
           label  = plotID,
           IDnum  = as.numeric(plotID)-1)%>%
    filter(!is.na(plotID))%>%ungroup()
  
  nodes2 <- data.frame(plotID = unique(c(m$source,m$destination)))%>%
    left_join(tbl, by=c("plotID"="plotID"))%>%
    group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    arrange(Category, plotID)%>%
    mutate(plotID = factor(plotID,tmp$plotID),
           lab    = Category,
           label  = plotID,
           IDnum  = as.numeric(plotID)-1)%>%
    filter(!is.na(plotID))%>%ungroup()
  
  m <- m%>%left_join(tmp, by=c("source" = "plotID"))
  
  
  # m <- m%>%mutate(source        = factor(source,tmp$plotID),
  #                 destination   = factor(destination,tmp$plotID),
  #                 IDsource      = as.numeric(source)-1,
  #                 IDdestination = as.numeric(destination)-1)
  
  cc          <- viridis_pal(alpha = 1, begin = 0, end = 1, direction = 1, option = "D")
  nodes2$cols <- cc(length(unique(nodes2$lab)))[as.numeric(as.factor(nodes2$lab))]
  nodes2$group <- as.numeric(as.factor(nodes2$lab))
  nodes2$id   <- as.numeric(as.factor(nodes2$plotID))
  
  edges    <- m%>%mutate(from=IDsource+1,to=IDdestination+1,label=source)
  nodes2   <- nodes2%>%mutate(group = Category)
  linksOut <- data.frame(m)
  nodesOut <- data.frame(nodes2)
  nodes1Out <- data.frame(nodes1)
  edgesOut <- data.frame(edges)
  
  
  return(list(nodes=nodesOut,nodes_2=nodes1Out,links =linksOut,edges=edgesOut))

}
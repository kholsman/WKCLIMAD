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
  by_category <- data.frame(ID = unique(c(links$source,links$destination)))%>%
    left_join(tbl, by=c("ID"="ID"))%>%
    group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    rowid_to_column("id")%>%
    rename(lab = Category)
  
  # Create matrix [correct]
  m   <- links%>%
    select(source,destination,value,weight_source,weight_dest)%>%
    left_join(tbl_meta, by=c("source"="ID_long"))%>%
    rename(plot_source = Plot_text, Category_source=Category)%>%
    left_join(tbl_meta, by=c("destination"="ID_long"))%>%
    rename(plot_dest = Plot_text, Category_dest=Category)%>%
    filter(!is.na(plot_dest))%>%
    left_join(by_category,by=c("plot_source"="plotID"))%>%
    select(plot_source,plot_dest, value)%>% 
    rename(source = plot_source, destination=plot_dest)%>%
    group_by(source,destination)%>%
    summarize(mean =mean(value,na.rm=T))%>%
    select(source,destination,mean)%>%
    filter(!is.na(source))%>%rename(value=mean)%>%ungroup()
  
  # With networkD3, connection must be provided using id, not using real 
  # name like in the links dataframe.. So we need to reformat it.
  
  m$IDsource      <- match(m$source, by_category$plotID)-1 
  m$IDdestination <- match(m$destination, by_category$plotID)-1
  
  nodes1 <-by_category%>%
    left_join(tbl, by=c("plotID"="plotID"))%>%
    group_by(plotID,Category,Type)%>%
    mutate(Type  = factor(Type,c( "Sub-components",
                                  "Supportive Elements",
                                  "Climate-informed Management Tool",
                                  "Adaptation Measures Addressed")),
           typeN  = as.numeric(Type))%>%
    summarize(freq=length(plotID),level = round(mean(typeN)),0)%>%
   mutate( plotID2 = paste0(level,plotID),
           #plotID= factor(plotID,by_category$plotID),
           lab    = Category,
           label  = plotID)%>%
           #IDnum  = as.numeric(plotID)-1)%>%
    filter(!is.na(plotID))%>%ungroup()
  
  nodes1$id   <- match(nodes1$plotID, by_category$plotID)-1 
  nodes2      <-by_category%>%
    left_join(tbl, by=c("plotID"="plotID"))%>%
    group_by(plotID,Category)%>%
    summarize(freq=length(plotID))%>%
    #arrange(Category, plotID)%>%
    mutate(
      #plotID = factor(plotID,by_category$plotID),
           lab    = Category,
           label  = plotID)%>%
             #IDnum  = as.numeric(plotID)-1)%>%
    filter(!is.na(plotID))
    
    nodes2$id      <- match(nodes2$plotID, by_category$plotID)-1 
    
    m <- m%>%left_join(by_category, by=c("source" = "plotID"))
  
  
  # m <- m%>%mutate(source        = factor(source,tmp$plotID),
  #                 destination   = factor(destination,tmp$plotID),
  #                 IDsource      = as.numeric(source)-1,
  #                 IDdestination = as.numeric(destination)-1)
  
  cc           <- viridis_pal(alpha = 1, begin = 0, end = 1, direction = 1, option = "D")
  nodes2$cols  <- cc(length(unique(nodes2$lab)))[as.numeric(as.factor(nodes2$lab))]
  nodes2$group <- as.numeric(as.factor(nodes2$lab))
  #nodes2$id    <- as.numeric(as.factor(nodes2$plotID))
  
  edges     <- m%>%mutate(from=IDsource+1,to=IDdestination+1,label=source)
  nodes2    <- nodes2%>%mutate(group = Category)
  linksOut  <- data.frame(m)
  nodesOut  <- data.frame(nodes2)
  nodes1Out <- data.frame(nodes1)
  edgesOut  <- data.frame(edges)
  
  
  return(list(nodes=nodesOut,nodes_2=nodes1Out,links =linksOut,edges=edgesOut))

}
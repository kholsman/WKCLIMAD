# Load package
# # devtools::install_github("mattflor/chorddiag")
# library(chorddiag)
# library(viridis)


  # load data
    load(file = file.path('Data/out/snakeymodels/links_all.Rdata'))
    load(file = file.path('Data/out/snakeymodels/nodes_all.Rdata'))
    
    load(file = file.path('Data/out/snakeymodels/tbl_meta.Rdata'))
    load(file = file.path('Data/out/snakeymodels/tbl.Rdata'))
    for(m in dirlist("Data/out/sankeymodels/"))

  # create a df from the meta data
    cc <- tbl%>%distinct(plotID,Category,Type)
    df <- tbl%>%group_by(plotID,Category)%>%summarise(freq=length(plotID))%>%
     arrange(desc(freq))
 
  # create collated matrix of all networks
  # combine with tbl_meta and reduce to plotID
  # collate to plot source()
  
    modlist <- F_3_3
  
  # create order for plotting
    cat <- data.frame(ID = unique(c(links_all$source,links_all$destination)))%>%
      left_join(tbl, by=c("ID"="ID"))
    
    by_category <- cat%>%group_by(plotID,Category)%>%
      summarize(freq=length(plotID))%>%
      arrange(Category, plotID)%>%
      mutate(plotID = factor(plotID,plotID))%>%rename(lab = Category)
    
    # Create matrix
    m   <- links_all%>%
      filter(value!=0.1, model%in%modlist)%>%
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
    p <- chorddiag(m,  
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
    p
    

  #install phantom:
  webshot::install_phantomjs()
  # Make a webshot in pdf : high quality but can not choose printed zone
  webshot("paste_your_html_here.html" , "output.pdf", delay = 0.2)
  
  # Make a webshot in png : Low quality - but you can choose shape
  webshot("paste_your_html_here" , "output.png", delay = 0.2 , cliprect = c(440, 0, 1000, 10))
  
  

  # create collated matrix by plotID

  m   <- links_all%>%select(source,destination,value)%>%
    left_join(tbl%>%select(ID,plotID),by=c("source"="ID"))%>%
    rename(source_plotID = plotID)%>%
    left_join(tbl%>%select(ID,plotID),by=c("destination"="ID"))%>%
    rename(destination_plotID = plotID)%>%
    select(source =source_plotID,destination = destination_plotID, value)%>%
    select(source,destination,value)%>%
    group_by(source,destination)%>%
    summarize(mean =mean(value,na.rm=T))%>%
    select(source,destination,mean)
  m <- na.omit(m)
    
  wide   <- m%>%
    pivot_wider(names_from = destination, values_from = mean, values_fill =NA)%>%
    pivot_longer(!source,names_to = "destination",values_to="mean")
  
  ## NOT WORKING???!!!
  
   rc   <- data.frame(Plot_text = unique(na.omit(c(wide$source,wide$destination))),
                      characters_as_strings=F)%>%
     left_join(tbl_meta)%>%
     arrange(Category ,Plot_text)%>%mutate(factor(Plot_text,Plot_text))
  
  matt <- expand.grid(unique(c(wide$source,wide$destination)),
                      unique(c(wide$source,wide$destination)))
  colnames(matt) <- c("source","destination")
 # matt$mean <-1
  
  full_mat<-matt%>%left_join(wide)%>%
    pivot_wider(names_from = destination, 
                values_from = mean, values_fill =NA)
  
  cc          <- viridis_pal(alpha = 1, begin = 0, end = 1, direction = 1, option = "D")
  meta_dat    <- data.frame(plotID =colnames(full_mat[,-1]))%>%left_join(tbl)
  m           <- data.matrix(full_mat[,-1])
  groupColors <- cc(length(unique(meta_dat$Type)))[as.numeric(as.factor(meta_dat$Type))]
  
  # Build the chord diagram:
  p <- chorddiag(m, groupColors = groupColors, groupnamePadding = 20)
  p
  
  
  
  
  
  
  
# Create a graph object
mygraph <- igraph::graph_from_data_frame( edges, vertices=vertices )

# The connection object must refer to the ids of the leaves:
from  <-  match( connect$from, vertices$name)
to  <-  match( connect$to, vertices$name)

# Basic usual argument
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05)) +
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, colour="skyblue", width=0.9) +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=name, angle = angle, hjust=hjust), size=1.5, alpha=1) +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))


ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, width=0.9, aes(colour=..index..)) +
  scale_edge_colour_distiller(palette = "RdPu") +
  
  geom_node_text(aes(x = x*1.15, y=y*1.15, filter = leaf, label=name, angle = angle, hjust=hjust, colour=group), size=2, alpha=1) +
  
  geom_node_point(aes(filter = leaf, x = x*1.07, y=y*1.07, colour=group, size=value, alpha=0.2)) +
  scale_colour_manual(values= rep( brewer.pal(9,"Paired") , 30)) +
  scale_size_continuous( range = c(0.1,10) ) +
  
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3))
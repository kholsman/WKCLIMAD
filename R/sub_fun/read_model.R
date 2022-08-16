#'
#'
#'
#'read_matrix.R
#'

#'
#'
#' read_network.R
#'
#' csv_file <- "data/shiny/01_CCTF_KKH.csv"
#' csv_file <- file.path("data/shiny",modlist[1])
#' readxl::read_xlsx(path=file.path(
#'  
read_model <- function(fl         = "Data/in/flow diagrams/frame 8_aquacultre_1_1.xlsx",
                       sheet_fl   = "frame8_aqua_1_1",
                       sizeIN     = 16, 
                       linkcolby  = "source",
                       NAval      = NA,
                       lkup       = "meta_data",
                       lkup_Sheet_adapt ="adapt_meta"){
  
  
  df <- readxl::read_xlsx(path=fl,
    sheet =sheet_fl, col_names =T)
  
  df[is.na(df)] <- NAval
  colnames(df)[1] <- "ID"
  
  links               <- reshape2::melt(df, na.rm = TRUE,id.vars="ID")
  names(links)        <- c("source","destination","value")
  links$source        <- as.character(links$source)
  links$destination   <- as.character(links$destination)
  links$value[which(links$value==0)] <-0.1
  
  # create links and nodes:
  # sources <- links %>%
  #   distinct(source) %>%
  #   rename(label = source)
  # 
  # destinations <- links %>%
  #   distinct(destination) %>%
  #   rename(label = destination)
  
 # nodes <- full_join(sources, destinations, by = "label")
  # From these flows we need to create a node data frame: it lists every entities involved in the flow
  nodes <- data.frame(
    label=c(as.character(links$source), as.character(links$destination)) %>% 
      unique()
  )%>%rowid_to_column("id")
  

  # With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
  links$IDsource      <- match(links$source, nodes$label)-1 
  links$IDdestination <- match(links$destination, nodes$label)-1
  
  # 
  # # Make the Network
  p <- sankeyNetwork(Links = links, Nodes = nodes,
                     Source = "IDsource", Target = "IDdestination",
                     Value = "value", NodeID = "label",
                     sinksRight=FALSE)

  # p
  
  # binary where weights are the number of links:
  per_route <- links %>%  
    group_by(source) %>%
    summarise(weight_source = n()) %>% 
    ungroup()
    
  links <- links %>%  
    left_join(per_route, by = c("source" = "source"))
  
  nodes <- nodes %>%  
    left_join(per_route, by = c("label" = "source"))
  
  
  per_route <- links %>%  
    group_by(destination) %>%
    summarise(weight_dest = n()) %>% 
    ungroup()
  
  links <- links %>%  
    left_join(per_route, by = c("destination" = "destination"))

  nodes <- nodes %>%  
    left_join(per_route, by = c("label" = "destination"))
  
  
  # #value (where negative or positive connections are the weights)
  # per_route <- links %>% 
  #   group_by(source) %>%
  #   summarise(weight = abs(value)) %>% 
  #   ungroup()
  
  

  
  if(!is.null(lkup)){
    tbl <- readxl::read_xlsx(path=fl,
                             sheet =lkup_Sheet, col_names =T)
    tbl <- tbl%>%filter(Sheet == sheet_fl)  #distinct(ID,Type)
    tbl$Sheet  <- as.factor(tbl$Sheet)
    tbl$Type  <- as.factor(tbl$Type)
    tbl$levels <- as.numeric(tbl$Type)


    nodes  <- nodes%>%left_join(tbl,by =c("label" = "ID"))
    
    
    eval(parse(text=paste0(
    "links  <- links%>%left_join(tbl,by =c(",linkcolby," = 'ID'))")))
    
    # adapt_meta <- readxl::read_xlsx(path=fl,
    #                                 sheet =lkup_Sheet_adapt, col_names =T)
    # 
    # sub <- adapt_meta%>%filter(Sheet== sheet_fl)%>%select(name,Category) #%>%distinct(name,Category) 

    # nodes  <- nodes%>%left_join(sub,by =c("label" = "name"))
    # eval(parse(text=paste0(
    #   "links  <- links%>%left_join(sub,by =c(",linkcolby," = 'name'))")))
    # 
    
   #nodes <-  merge(nodes,tbl, by.x = "label",by.y ="ID",all.x = T)
    
    
  }else{
    nodes$Group  <- "id"
    nodes$Type   <- ""
    nodes$levels <- 1
    nodes$icon   <-NULL
    nodes$Category <-""
  }
  

  edges2    <- edges%>%
    select(from, to, weight_source)%>%
    mutate(width = weight_source/5 + 1)
    
  nodes_d3  <- nodes
  #nodes_d3 <- mutate(nodes, id = id - 1)
  edges_d3 <- mutate(edges2, from = from - 1, to = to - 1)
  nodesVis <- nodes%>%mutate(font.size = sizeIN*3)
  
  
 # out_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)
  
  return(list(
    #network= out_network, 
    edges=edges, 
    links=links,
    edges2= edges2,
    edges_d3 = edges_d3,
    per_route = per_route, 
    nodes = nodes, 
    nodesVis = nodesVis,
    nodes_d3 = nodes_d3,
    destinations = destinations, 
    sources =sources ))
  
}
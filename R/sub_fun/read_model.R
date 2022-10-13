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
if(1==10){
  fl         = "Data/in/flow diagrams/mentalmodels"
  model   = models[6]
  sizeIN     = 16
  linkcolby  = "source"
  NAval      = NA
  lkup       = "../Day5_MetaData.xlsx"
  lkup_Sheet_adapt ="meta_data"
}
read_model <- function(fl         = "Data/in/flow diagrams/mentalmodels",
                       model      = "Fish_1_1",
                       sizeIN     = 16, 
                       linkcolby  = "source",
                       NAval      = NA,
                       lkup       = "../Day5_MetaData.xlsx",
                       lkup_Sheet_adapt ="meta_data"){
  
  

  df <- read.csv(file.path(fl,paste0(model,".csv")), header=T)
  colnames(df)[-1] <- df[,1]
  df[is.na(df)] <- NAval
  colnames(df)[1] <- "ID"
  
  links               <- reshape2::melt(df, na.rm = TRUE,id.vars="ID")
  names(links)        <- c("source","destination","value")
  links$source        <- as.character(links$source)
  links$destination   <- as.character(links$destination)

  #links$value[which(links$value==0)] <-0.1
  
  # create links and nodes:
  # sources <- links %>%
  #   distinct(source) %>%
  #   rename(label = source)
  
  # destinations <- links %>%
  #   distinct(destination) %>%
  #   rename(label = destination)
  
  # nodes <- full_join(sources, destinations, by = "label")
  # From these flows we need to create a node data frame: 
  # it lists every entities involved in the flow
  
  nodes <- data.frame(
    label=c(as.character(links$source), 
            as.character(links$destination)) %>% 
      unique())%>%rowid_to_column("id")
  
  # With networkD3, connection must be provided using id, not using real 
  # name like in the links dataframe.. So we need to reformat it.
  
  links$IDsource      <- match(links$source, nodes$label)-1 
  links$IDdestination <- match(links$destination, nodes$label)-1
 
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
  
  tblall<-NA
  if(!is.null(lkup)){
    tbl_meta <- na.omit(readxl::read_xlsx(path=file.path(fl,lkup),
                                          range = "A1:C500",
                                  sheet ="lkup_tables", col_names =T))
    tbl      <- readxl::read_xlsx(path=file.path(fl,lkup),
                                  sheet =lkup_Sheet_adapt, col_names =T)
    tbl <- tbl%>%filter(plotID!="NA")
    tblall <- tbl
    
    tbl <- tbl%>%filter(Model == model)  #distinct(ID,Type)
    tbl$Model  <- as.factor(tbl$Model)
    tbl$Type   <- as.factor(tbl$Type)
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

  nodes <- nodes%>%filter(!is.na(plotID ))
  # %>%mutate(value=weight_source)
  # nodes$value[is.na(nodes$value)]<-0
  edges <- links %>%
    left_join(nodes%>%select(id,label), by = c("source" = "label")) %>% 
    mutate(from = IDsource,to = IDdestination)%>%filter(!is.na(source),!is.na(destination))
  
  edges2    <- edges%>%
    select(from, to, weight_source)%>%
    mutate(width = weight_source/5 + 1)
    
  nodes_d3 <- nodes
  nodes_d3 <- mutate(nodes, id = id - 1)
  edges_d3 <- mutate(edges2, from = from - 1, to = to - 1)
  nodesVis <- nodes%>%mutate(font.size = sizeIN*3)
  
  #out_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)
  
 # out_network <- network(edges2, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE, loops = T)
  
  return(list(
    #network= out_network, 
    df = df,
    tbl = tblall,
    tbl_meta = tbl_meta,
    edges=edges, 
    links=links,
    edges2= edges2,
    edges_d3 = edges_d3,
    per_route = per_route, 
    nodes = nodes, 
    nodesVis = nodesVis,
    nodes_d3 = nodes_d3,
    destinations = links$destination, 
    sources =links$source ))
  
}